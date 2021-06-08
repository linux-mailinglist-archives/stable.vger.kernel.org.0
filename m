Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF383A01CE
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235591AbhFHS42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:56:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:49356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236529AbhFHSyc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:54:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65179613BC;
        Tue,  8 Jun 2021 18:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177674;
        bh=cF2gf06p0ZjoCP7ov+Qa0PZo0uMfYOcFQQ/ahArk0Vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0QGLMoNqlAEKqkf0qEoy+v5Vr1O+AOxm1LykJYRedhVo46bJfaYxogSn7uX41H62G
         CSv0aBMQyR8VJIH2k3OE5bDh9EHXgzUXsy+sje49nCMXqJZvbQ64MZBVtSO8XxSLJi
         JcIClKrHRC7akgIMNCLCr5fiujhc/NhdkyLE+dFk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jesper Dangaard Brouer <brouer@redhat.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Vishakha Jambekar <vishakha.jambekar@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 041/137] igb: add correct exception tracing for XDP
Date:   Tue,  8 Jun 2021 20:26:21 +0200
Message-Id: <20210608175943.798969224@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit 74431c40b9c5fa673fff83ec157a76a69efd5c72 ]

Add missing exception tracing to XDP when a number of different
errors can occur. The support was only partial. Several errors
where not logged which would confuse the user quite a lot not
knowing where and why the packets disappeared.

Fixes: 9cbc948b5a20 ("igb: add XDP support")
Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Tested-by: Vishakha Jambekar <vishakha.jambekar@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 368f0aac5e1d..5c87c0a7ce3d 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -8419,18 +8419,20 @@ static struct sk_buff *igb_run_xdp(struct igb_adapter *adapter,
 		break;
 	case XDP_TX:
 		result = igb_xdp_xmit_back(adapter, xdp);
+		if (result == IGB_XDP_CONSUMED)
+			goto out_failure;
 		break;
 	case XDP_REDIRECT:
 		err = xdp_do_redirect(adapter->netdev, xdp, xdp_prog);
-		if (!err)
-			result = IGB_XDP_REDIR;
-		else
-			result = IGB_XDP_CONSUMED;
+		if (err)
+			goto out_failure;
+		result = IGB_XDP_REDIR;
 		break;
 	default:
 		bpf_warn_invalid_xdp_action(act);
 		fallthrough;
 	case XDP_ABORTED:
+out_failure:
 		trace_xdp_exception(rx_ring->netdev, xdp_prog, act);
 		fallthrough;
 	case XDP_DROP:
-- 
2.30.2



