Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3E234CA98
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234403AbhC2IjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:39:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:56230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234914AbhC2Ihf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 468306196E;
        Mon, 29 Mar 2021 08:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007044;
        bh=6GlC2+1Kik4I1fN3VDmxXUiskJCS6rKSVODO2sGCz2Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hX+5E4ExGWB8fkGDYphC+pCRsEyZ3cRxD7QDmlmGCmqUXOh8DTT4jOa7Q45fMUyIz
         Xwc5H8agupfuxKpvZ+xu1ZheRAyygXFJ4HTr37+RcU53z1KW3qRVSBTRro/Gs+iAFM
         zCOzW7ifZ3the3DufMMpHft2fEvIKHOg8HmoAADg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, wenxu <wenxu@ucloud.cn>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 165/254] net/sched: cls_flower: fix only mask bit check in the validate_ct_state
Date:   Mon, 29 Mar 2021 09:58:01 +0200
Message-Id: <20210329075638.602018954@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

[ Upstream commit afa536d8405a9ca36e45ba035554afbb8da27b82 ]

The ct_state validate should not only check the mask bit and also
check mask_bit & key_bit..
For the +new+est case example, The 'new' and 'est' bits should be
set in both state_mask and state flags. Or the -new-est case also
will be reject by kernel.
When Openvswitch with two flows
ct_state=+trk+new,action=commit,forward
ct_state=+trk+est,action=forward

A packet go through the kernel  and the contrack state is invalid,
The ct_state will be +trk-inv. Upcall to the ovs-vswitchd, the
finally dp action will be drop with -new-est+trk.

Fixes: 1bcc51ac0731 ("net/sched: cls_flower: Reject invalid ct_state flags rules")
Fixes: 3aed8b63336c ("net/sched: cls_flower: validate ct_state for invalid and reply flags")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_flower.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 46c1b3e9f66a..14316ba9b3b3 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -1432,7 +1432,7 @@ static int fl_set_key_ct(struct nlattr **tb,
 			       &mask->ct_state, TCA_FLOWER_KEY_CT_STATE_MASK,
 			       sizeof(key->ct_state));
 
-		err = fl_validate_ct_state(mask->ct_state,
+		err = fl_validate_ct_state(key->ct_state & mask->ct_state,
 					   tb[TCA_FLOWER_KEY_CT_STATE_MASK],
 					   extack);
 		if (err)
-- 
2.30.1



