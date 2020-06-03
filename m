Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE541ECAE5
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 10:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725881AbgFCIAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 04:00:11 -0400
Received: from mail5.windriver.com ([192.103.53.11]:56462 "EHLO mail5.wrs.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725828AbgFCIAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jun 2020 04:00:11 -0400
Received: from ALA-HCA.corp.ad.wrs.com (ala-hca.corp.ad.wrs.com [147.11.189.40])
        by mail5.wrs.com (8.15.2/8.15.2) with ESMTPS id 0537x91P020011
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL);
        Wed, 3 Jun 2020 00:59:19 -0700
Received: from otp-linux01.wrs.com (128.224.126.17) by ALA-HCA.corp.ad.wrs.com
 (147.11.189.40) with Microsoft SMTP Server id 14.3.487.0; Wed, 3 Jun 2020
 00:58:58 -0700
From:   Ovidiu Panait <ovidiu.panait@windriver.com>
To:     <xiao.zhang@windriver.com>, <yue.tao@windriver.com>
CC:     <lpd-eng-rr@windriver.com>, <stable@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: Review request for LIN1019-4731/LIN1018-6238 Security Advisory - linux - CVE-2020-10751
Date:   Wed, 3 Jun 2020 10:57:00 +0300
Message-ID: <20200603075701.33568-1-ovidiu.panait@windriver.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Summary: Security Advisory - linux - CVE-2020-10751
Tech Review: Xiao
Gatekeeper: Yue Tao
Lockdown Approval (if needed):
Branch Tag: LTS19, LTS18

IP Statement (form link or license statement, usually automated):
Crypto URL(s) (if needed): see http://wiki.wrs.com/PBUeng/LinuxProductDivisionExportProcess
Parent Template (where applicable):


-------------------------------------
Impacted area             Impact y/n
-------------------       -----------
docs/tech-pubs                 n
tests                          n
build system                   n
host dependencies              n
RPM/packaging                  n
toolchain                      n
kernel code                    y
user code                      n
configuration files            n
target configuration           n
Other                          n
Applicable to Yocto/upstream   n
New Kernel Warnings            n


Comments (indicate scope for each "y" above):
---------------------------------------------
From 11d31c9c777c235630d9a72bf316f48c5036e609 Mon Sep 17 00:00:00 2001
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 28 Apr 2020 09:59:02 -0400
Subject: [PATCH] selinux: properly handle multiple messages in
 selinux_netlink_send()

commit fb73974172ffaaf57a7c42f35424d9aece1a5af6 upstream.

Fix the SELinux netlink_send hook to properly handle multiple netlink
messages in a single sk_buff; each message is parsed and subject to
SELinux access control.  Prior to this patch, SELinux only inspected
the first message in the sk_buff.

Cc: stable@vger.kernel.org
Reported-by: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[OP: backport of eeef0d9fd40 from branch linux-5.4.y of linux-stable]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>

Added Files:
------------
No.

Removed Files:
--------------
No.

Remaining Changes (diffstat):
-----------------------------
 security/selinux/hooks.c | 70 ++++++++++++++++++++++++++--------------
 1 file changed, 45 insertions(+), 25 deletions(-)

Testing Applicable to:
----------------------
intel-x86-64

Testing Commands:
-----------------
CONFIG_SECURITY_SELINUX=y
bitbake virtual/kernel

Testing, Expected Results:
--------------------------
Build OK. No build err/warning caused by this modification.

Conditions of submission:
-------------------------
Build OK. No build err/warning caused by this modification.
Boot in qemu OK.

Arch    built      boot     boardname
-------------------------------------
MIPS      n         n
MIPS64    n         n
MIPS64n32 n         n
ARM32     n         n
ARM64     n         n
x86       n         n
x86_64    y         n       intel-x86-64
PPC       n         n
PPC64     n         n
SPARC64   n         n


