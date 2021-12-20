Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05D5A47ACF7
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:48:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236760AbhLTOsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:48:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38566 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236275AbhLTOqC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:46:02 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77B1661165;
        Mon, 20 Dec 2021 14:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8778AC36AE9;
        Mon, 20 Dec 2021 14:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011560;
        bh=d+/gY9c2xA9+eLrDX51PkG3V/Y/0vFW+9FoAWStkb2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x9U2g0n1z6ww9uOIEfgzBHX8w6DPLA5543EW+SuskeBKHMN/g62aFEQ0Tx3pcAfwh
         tyJhyyPjHg31Q7YaUFK7XgaXdn/scLa0aktsaICOSy/Ac280bFRCUOCTiLND6AWCgD
         AtBS9pBN4MQwfOS4FrVRCpR+WmoaEaEVYbPPhNrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baowen Zheng <baowen.zheng@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 32/71] flow_offload: return EOPNOTSUPP for the unsupported mpls action type
Date:   Mon, 20 Dec 2021 15:34:21 +0100
Message-Id: <20211220143026.765103269@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baowen Zheng <baowen.zheng@corigine.com>

[ Upstream commit 166b6a46b78bf8b9559a6620c3032f9fe492e082 ]

We need to return EOPNOTSUPP for the unsupported mpls action type when
setup the flow action.

In the original implement, we will return 0 for the unsupported mpls
action type, actually we do not setup it and the following actions
to the flow action entry.

Fixes: 9838b20a7fb2 ("net: sched: take rtnl lock in tc_setup_flow_action()")
Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 61aa63cc170b4..a4c61205462ac 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3562,6 +3562,7 @@ int tc_setup_flow_action(struct flow_action *flow_action,
 				entry->mpls_mangle.ttl = tcf_mpls_ttl(act);
 				break;
 			default:
+				err = -EOPNOTSUPP;
 				goto err_out_locked;
 			}
 		} else if (is_tcf_skbedit_ptype(act)) {
-- 
2.33.0



