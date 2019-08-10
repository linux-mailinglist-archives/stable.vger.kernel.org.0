Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D18388E26
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727504AbfHJUwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:52:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54130 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726578AbfHJUnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:52 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDN-00053s-56; Sat, 10 Aug 2019 21:43:49 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDK-0003bn-8n; Sat, 10 Aug 2019 21:43:46 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>,
        "Paolo Bonzini" <pbonzini@redhat.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.308888712@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 054/157] KVM: Reject device ioctls from processes
 other than the VM's creator
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit ddba91801aeb5c160b660caed1800eb3aef403f8 upstream.

KVM's API requires thats ioctls must be issued from the same process
that created the VM.  In other words, userspace can play games with a
VM's file descriptors, e.g. fork(), SCM_RIGHTS, etc..., but only the
creator can do anything useful.  Explicitly reject device ioctls that
are issued by a process other than the VM's creator, and update KVM's
API documentation to extend its requirements to device ioctls.

Fixes: 852b6d57dc7f ("kvm: add device control API")
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 Documentation/virtual/kvm/api.txt | 16 +++++++++++-----
 virt/kvm/kvm_main.c               |  3 +++
 2 files changed, 14 insertions(+), 5 deletions(-)

--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -13,7 +13,7 @@ of a virtual machine.  The ioctls belong
 
  - VM ioctls: These query and set attributes that affect an entire virtual
    machine, for example memory layout.  In addition a VM ioctl is used to
-   create virtual cpus (vcpus).
+   create virtual cpus (vcpus) and devices.
 
    Only run VM ioctls from the same process (address space) that was used
    to create the VM.
@@ -24,6 +24,11 @@ of a virtual machine.  The ioctls belong
    Only run vcpu ioctls from the same thread that was used to create the
    vcpu.
 
+ - device ioctls: These query and set attributes that control the operation
+   of a single device.
+
+   device ioctls must be issued from the same process (address space) that
+   was used to create the VM.
 
 2. File descriptors
 -------------------
@@ -32,10 +37,11 @@ The kvm API is centered around file desc
 open("/dev/kvm") obtains a handle to the kvm subsystem; this handle
 can be used to issue system ioctls.  A KVM_CREATE_VM ioctl on this
 handle will create a VM file descriptor which can be used to issue VM
-ioctls.  A KVM_CREATE_VCPU ioctl on a VM fd will create a virtual cpu
-and return a file descriptor pointing to it.  Finally, ioctls on a vcpu
-fd can be used to control the vcpu, including the important task of
-actually running guest code.
+ioctls.  A KVM_CREATE_VCPU or KVM_CREATE_DEVICE ioctl on a VM fd will
+create a virtual cpu or device and return a file descriptor pointing to
+the new resource.  Finally, ioctls on a vcpu or device fd can be used
+to control the vcpu or device.  For vcpus, this includes the important
+task of actually running guest code.
 
 In general file descriptors can be migrated among processes by means
 of fork() and the SCM_RIGHTS facility of unix domain socket.  These
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2240,6 +2240,9 @@ static long kvm_device_ioctl(struct file
 {
 	struct kvm_device *dev = filp->private_data;
 
+	if (dev->kvm->mm != current->mm)
+		return -EIO;
+
 	switch (ioctl) {
 	case KVM_SET_DEVICE_ATTR:
 		return kvm_device_ioctl_attr(dev, dev->ops->set_attr, arg);

