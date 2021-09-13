Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453C1409309
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344292AbhIMORN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:17:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:37086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242081AbhIMOPM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:15:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8E9CB61AF7;
        Mon, 13 Sep 2021 13:44:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540647;
        bh=7EsTNrhMloFM0bqOLE3itASJWsogX4jXXnrrw9+HEms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EPHqCI3ZblGBlVQ5f5ONNJFSNKkLyeYavLd2RcjaDSwmN9HNlSXuI5XjF3NZ5YyWP
         jO2dU8PnFH1lslJQNg3By7udeDyINWlSDi7tTBYF9CjfF9LigozgLtsDNjMh9UpXRo
         TqP+KbVzAfchYjQjFclum+b7e7EIrZDFa4d7G7bg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Terry Bowman <Terry.Bowman@amd.com>,
        kernel test robot <lkp@intel.com>,
        Babu Moger <babu.moger@amd.com>, Borislav Petkov <bp@suse.de>,
        Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 5.13 279/300] x86/resctrl: Fix a maybe-uninitialized build warning treated as error
Date:   Mon, 13 Sep 2021 15:15:40 +0200
Message-Id: <20210913131118.770208001@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
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
 arch/x86/kernel/cpu/resctrl/monitor.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kernel/cpu/resctrl/monitor.c
+++ b/arch/x86/kernel/cpu/resctrl/monitor.c
@@ -304,6 +304,12 @@ static u64 __mon_event_count(u32 rmid, s
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


