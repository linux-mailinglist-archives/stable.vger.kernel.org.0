Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D748660B97
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 02:46:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjAGBqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 20:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbjAGBqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 20:46:43 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962FF87935
        for <stable@vger.kernel.org>; Fri,  6 Jan 2023 17:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673056002; x=1704592002;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=iTh16ITNNvW1Q0l/LFoKifGNe3GuHiKv0MuFonpu8VA=;
  b=Z6mJcuPk/0rRk6eoMInG+2IBwhcwpxyPWchk14vC0SDG3bajsMXcRmVA
   2AC3rnVOXOrCtUuGcM6uWuQsh6dE017hzxH5rEBN95m+N2lC9lHBH/NUU
   B5u3re2hr79jGc1xP7FRphko6VRLYnwwStjD3XY86M0y/wLULK195rHjt
   f3FaNBNn+LiuldGkePWNaBIpwg3byRAWP6IYeAr1cRAXhYl1G74rDKyaY
   uKMhOXbuEOGdHWLuo+xgGbUqSQj8SeQOqzAUjXmHRcGbt+lOTH46HqLAd
   S5IHdcq45knc+WXe3CV3A06J+BALJXV3MrPh58StK2Ow3PT4PJeFMMeg5
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="310393545"
X-IronPort-AV: E=Sophos;i="5.96,307,1665471600"; 
   d="scan'208";a="310393545"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 17:46:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10582"; a="606066133"
X-IronPort-AV: E=Sophos;i="5.96,307,1665471600"; 
   d="scan'208";a="606066133"
Received: from mechevar-mobl.amr.corp.intel.com (HELO mjmartin-desk2.intel.com) ([10.209.66.63])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2023 17:46:42 -0800
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     Mat Martineau <mathew.j.martineau@linux.intel.com>,
        matthieu.baerts@tessares.net, pabeni@redhat.com,
        mptcp@lists.linux.dev
Subject: [PATCH 5.10 0/4] mptcp: Stable backports for MPTCP request sock fixes
Date:   Fri,  6 Jan 2023 17:46:27 -0800
Message-Id: <20230107014631.449550-1-mathew.j.martineau@linux.intel.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg -

Here are backports of the MPTCP patches, and one prerequisite, that
recently failed to apply to the 5.10 stable tree. They prevent IPv6
memory leaks with MPTCP.

Thanks!


Florian Westphal (1):
  mptcp: mark ops structures as ro_after_init

Matthieu Baerts (3):
  mptcp: remove MPTCP 'ifdef' in TCP SYN cookies
  mptcp: dedicated request sock for subflow in v6
  mptcp: use proper req destructor for IPv6

 include/net/mptcp.h   | 12 +++++--
 net/ipv4/syncookies.c |  7 ++--
 net/mptcp/subflow.c   | 76 +++++++++++++++++++++++++++++++++----------
 3 files changed, 71 insertions(+), 24 deletions(-)

-- 
2.39.0

