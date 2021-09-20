Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA62411D73
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346928AbhITRU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348244AbhITRSg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:18:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC12361A50;
        Mon, 20 Sep 2021 16:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157185;
        bh=aGg5JDs8P/OzYUyzWhsHIwOhdg5PVjqNojD/CQ1CZvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqTd7SenWs1to/UvAL8FmALvmP3zG4qpmTkE2H/ZuyqXLBcAEWJvFdzuCfvWNUOcj
         5uP72koKFcL03IKlfRJ+p8eWQPbhDb/qjW07CPJ7uZe5Mar1oQuoiG1PcWPMbyd2Ay
         bcUSlT3woQfVyegyZC+0dOABtvVodvzelEeGwiXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Terry Bowman <Terry.Bowman@amd.com>,
        kernel test robot <lkp@intel.com>,
        Babu Moger <babu.moger@amd.com>, Borislav Petkov <bp@suse.de>,
        Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4.14 092/217] x86/resctrl: Fix a maybe-uninitialized build warning treated as error
Date:   Mon, 20 Sep 2021 18:41:53 +0200
Message-Id: <20210920163927.752230686@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Babu Moger <babu.moger@amd.com>

commit 527f721478bce3f49b513a733bacd19d6f34b08c upstream.

The recent commit

  064855a69003 ("x86/resctrl: Fix default monitoring groups reporting")

caused a RHEL build failure with an uninitialized variable warning
treated as an error because it removed the default case snippet.

The RHEL Makefile uses '-Werror=maybe-uninitialized' to force possibly
uninitialized variable warnings to be treated as errors. This is also
reported by smatch via the 0day robot.

The error from the RHEL build is:

  arch/x86/kernel/cpu/resctrl/monitor.c: In function ‘__mon_event_count’:
  arch/x86/kernel/cpu/resctrl/monitor.c:261:12: error: ‘m’ may be used
  uninitialized in this function [-Werror=maybe-uninitialized]
    m->chunks += chunks;
              ^~

The upstream Makefile does not build using '-Werror=maybe-uninitialized'.
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
Link: https://lkml.kernel.org/r/162949631908.23903.17090272726012848523.stgit@bmoger-ubuntu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/intel_rdt_monitor.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kernel/cpu/intel_rdt_monitor.c
+++ b/arch/x86/kernel/cpu/intel_rdt_monitor.c
@@ -244,6 +244,12 @@ static u64 __mon_event_count(u32 rmid, s
 	case QOS_L3_MBM_LOCAL_EVENT_ID:
 		m = &rr->d->mbm_local[rmid];
 		break;
+	default:
+		/*
+		 * Code would never reach here because an invalid
+		 * event id would fail the __rmid_read.
+		 */
+		return RMID_VAL_ERROR;
 	}
 
 	if (rr->first) {


