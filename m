Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 957BE1455C7
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731160AbgAVNZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:25:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731151AbgAVNZH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:25:07 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2611A24688;
        Wed, 22 Jan 2020 13:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699506;
        bh=+CqEos7/aIv8ITK1vvdTOwiWRvGqm2psdhrENFvh4is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OccRh5e7KV3MQj7BS5yI5SLATt0T1wI5wGtv8tmhBqSSsqoGz+EJkk/LKr4y2LM6G
         xE4Kngbx7MhgFdoRtCUP74UB+kfS96zDfxLexK8H0J00aEcsas+L+eUFtYljp7FtTS
         qdM2A9FfnCPMEZ15DhFeZZKGYC9uOilp7018tm0o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 149/222] bnxt_en: Fix NTUPLE firmware command failures.
Date:   Wed, 22 Jan 2020 10:28:55 +0100
Message-Id: <20200122092844.394182716@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit ceb3284c588eee5ea256c70e4d8d7cf399b8134e ]

The NTUPLE related firmware commands are sent to the wrong firmware
channel, causing all these commands to fail on new firmware that
supports the new firmware channel.  Fix it by excluding the 3
NTUPLE firmware commands from the list for the new firmware channel.

Fixes: 760b6d33410c ("bnxt_en: Add support for 2nd firmware message channel.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1904,9 +1904,6 @@ static inline bool bnxt_cfa_hwrm_message
 	case HWRM_CFA_ENCAP_RECORD_FREE:
 	case HWRM_CFA_DECAP_FILTER_ALLOC:
 	case HWRM_CFA_DECAP_FILTER_FREE:
-	case HWRM_CFA_NTUPLE_FILTER_ALLOC:
-	case HWRM_CFA_NTUPLE_FILTER_FREE:
-	case HWRM_CFA_NTUPLE_FILTER_CFG:
 	case HWRM_CFA_EM_FLOW_ALLOC:
 	case HWRM_CFA_EM_FLOW_FREE:
 	case HWRM_CFA_EM_FLOW_CFG:


