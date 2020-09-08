Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 128ED261B2C
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:58:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgIHS6u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:58:50 -0400
Received: from ex13-edg-ou-001.vmware.com ([208.91.0.189]:51744 "EHLO
        EX13-EDG-OU-001.vmware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729014AbgIHS6j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Sep 2020 14:58:39 -0400
Received: from sc9-mailhost3.vmware.com (10.113.161.73) by
 EX13-EDG-OU-001.vmware.com (10.113.208.155) with Microsoft SMTP Server id
 15.0.1156.6; Tue, 8 Sep 2020 11:58:37 -0700
Received: from akaher-virtual-machine.eng.vmware.com (unknown [10.197.103.239])
        by sc9-mailhost3.vmware.com (Postfix) with ESMTP id C256E40B4F;
        Tue,  8 Sep 2020 11:58:38 -0700 (PDT)
From:   Ajay Kaher <akaher@vmware.com>
To:     <gregkh@linuxfoundation.org>, <sashal@kernel.org>
CC:     <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <peterx@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <srivatsab@vmware.com>, <srivatsa@csail.mit.edu>,
        <vsirnapalli@vmware.com>, <akaher@vmware.com>
Subject: [PATCH v2 v4.14.y 0/3] vfio: Fix for CVE-2020-12888
Date:   Wed, 9 Sep 2020 00:24:23 +0530
Message-ID: <1599591263-46520-4-git-send-email-akaher@vmware.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1599591263-46520-1-git-send-email-akaher@vmware.com>
References: <1599591263-46520-1-git-send-email-akaher@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain
Received-SPF: None (EX13-EDG-OU-001.vmware.com: akaher@vmware.com does not
 designate permitted sender hosts)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

CVE-2020-12888 Kernel: vfio: access to disabled MMIO space of some
devices may lead to DoS scenario
    
The VFIO modules allow users (guest VMs) to enable or disable access to the
devices' MMIO memory address spaces. If a user attempts to access (read/write)
the devices' MMIO address space when it is disabled, some h/w devices issue an
interrupt to the CPU to indicate a fatal error condition, crashing the system.
This flaw allows a guest user or process to crash the host system resulting in
a denial of service.
    
Patch 1/ is to force the user fault if PFNMAP vma might be DMA mapped
before user access.
    
Patch 2/ setup a vm_ops handler to support dynamic faulting instead of calling
remap_pfn_range(). Also provides a list of vmas actively mapping the area which
can later use to invalidate those mappings.
    
Patch 3/ block the user from accessing memory spaces which is disabled by using
new vma list support to zap, or invalidate, those memory mappings in order to
force them to be faulted back in on access.
    
Upstreamed patches link:
https://lore.kernel.org/kvm/158871401328.15589.17598154478222071285.stgit@gimli.home

Diff from v1:
Fixed build break problem.

[PATCH v2 v4.14.y 1/3]:
Backporting of upsream commit 41311242221e:
vfio/type1: Support faulting PFNMAP vmas
        
[PATCH v2 v4.14.y 2/3]:
Backporting of upsream commit 11c4cd07ba11:
vfio-pci: Fault mmaps to enable vma tracking
        
[PATCH v2 v4.14.y 3/3]:
Backporting of upsream commit abafbc551fdd:
vfio-pci: Invalidate mmaps and block MMIO access on disabled memory
