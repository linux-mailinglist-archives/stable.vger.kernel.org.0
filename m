Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0B93F3E48
	for <lists+stable@lfdr.de>; Sun, 22 Aug 2021 09:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbhHVH0e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Aug 2021 03:26:34 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:33328 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbhHVH0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Aug 2021 03:26:34 -0400
Date:   Sun, 22 Aug 2021 07:25:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1629617152;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BDaJ8gq1y2CCb9HbdovkJsuoTT2Ott+UnFGCWMcbZ1s=;
        b=j8J2xDUjqMbDZ8tLD4Ns7KzQnGOC6+VfXjaJpfd5g26eM66Cu75J7Wzn5aBzcoRKIr3CZw
        qHrZrUBI10rNNesoqjvvknfdjL6nh1NxGsFWcO+T2KS676JEH/mtnn/pT3zJtc/zhkVN5H
        mMEjdQ+BQ3zqfWyIqdB7JWkeFGoctRxRTBYVDsKNf3tLMHNouvIQ5FcjpB18u8najg+jUW
        utdBJ1mfmBNy2zEoOj0BFALFXKf/MWjotDth4cGZ/UFIeHqaoEMqWPcxwUoDosrXGTQkJg
        3QKotZ8uGNPCkQ2TwzuUOfm9BCiDBlRn4uY5ftnEcleyx21RbhdDt7+E789LqQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1629617152;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BDaJ8gq1y2CCb9HbdovkJsuoTT2Ott+UnFGCWMcbZ1s=;
        b=2mJQQJ9rWYEBE+ORbmghjg6TfLrGLBac0hveQpFvheUL0Pu7xehOS/xacJbwGUSZ+GknMY
        +xk8xA070kmmhmBg==
From:   "tip-bot2 for Babu Moger" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/resctrl: Fix a maybe-uninitialized build
 warning treated as error
Cc:     Terry Bowman <Terry.Bowman@amd.com>,
        kernel test robot <lkp@intel.com>,
        Babu Moger <babu.moger@amd.com>, Borislav Petkov <bp@suse.de>,
        Reinette Chatre <reinette.chatre@intel.com>,
        stable@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <162949631908.23903.17090272726012848523.stgit@bmoger-ubuntu>
References: <162949631908.23903.17090272726012848523.stgit@bmoger-ubuntu>
MIME-Version: 1.0
Message-ID: <162961715100.25758.14486039318102865041.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     527f721478bce3f49b513a733bacd19d6f34b08c
Gitweb:        https://git.kernel.org/tip/527f721478bce3f49b513a733bacd19d6f3=
4b08c
Author:        Babu Moger <babu.moger@amd.com>
AuthorDate:    Fri, 20 Aug 2021 16:52:42 -05:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Sun, 22 Aug 2021 09:11:29 +02:00

x86/resctrl: Fix a maybe-uninitialized build warning treated as error

The recent commit

  064855a69003 ("x86/resctrl: Fix default monitoring groups reporting")

caused a RHEL build failure with an uninitialized variable warning
treated as an error because it removed the default case snippet.

The RHEL Makefile uses '-Werror=3Dmaybe-uninitialized' to force possibly
uninitialized variable warnings to be treated as errors. This is also
reported by smatch via the 0day robot.

The error from the RHEL build is:

  arch/x86/kernel/cpu/resctrl/monitor.c: In function =E2=80=98__mon_event_cou=
nt=E2=80=99:
  arch/x86/kernel/cpu/resctrl/monitor.c:261:12: error: =E2=80=98m=E2=80=99 ma=
y be used
  uninitialized in this function [-Werror=3Dmaybe-uninitialized]
    m->chunks +=3D chunks;
              ^~

The upstream Makefile does not build using '-Werror=3Dmaybe-uninitialized'.
So, the problem is not seen there. Fix the problem by putting back the
default case snippet.

 [ bp: note that there's nothing wrong with the code and other compilers
   do not trigger this warning - this is being done just so the RHEL compiler
   is happy. ]

Fixes: 064855a69003 ("x86/resctrl: Fix default monitoring groups reporting")
Reported-by: Terry Bowman <Terry.Bowman@amd.com>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/162949631908.23903.17090272726012848523.stgit=
@bmoger-ubuntu
---
 arch/x86/kernel/cpu/resctrl/monitor.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/monitor.c b/arch/x86/kernel/cpu/resc=
trl/monitor.c
index 57e4bb6..8caf871 100644
--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -304,6 +304,12 @@ static u64 __mon_event_count(u32 rmid, struct rmid_read =
*rr)
 	case QOS_L3_MBM_LOCAL_EVENT_ID:
 		m =3D &rr->d->mbm_local[rmid];
 		break;
+	default:
+		/*
+		 * Code would never reach here because an invalid
+		 * event id would fail the __rmid_read.
+		 */
+		return RMID_VAL_ERROR;
 	}
=20
 	if (rr->first) {
