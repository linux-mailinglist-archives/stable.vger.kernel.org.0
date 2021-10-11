Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E09429057
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:07:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241373AbhJKOH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:56332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239626AbhJKOFZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:05:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 848EB60EFE;
        Mon, 11 Oct 2021 13:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960777;
        bh=arfcURbsQfppmq91R9DdHmfGPrVagpm0wAbOtRxWn0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BR7WZhTztuUBViMLn0LjmiyFy/7BaaXKw3Mx8UiB6TTqt3wUzP9Dyh75HmCS65wA9
         DVLUlv2FEmvr7hQgd/C2rGmbs1ZqZ9x/an5L2Ll2FeClXXuk6Dl2GeDUfDzXKdqbZx
         M4zx//68YpgO8EhavKjg2G5U5ErLLKgWWNnFaloE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 070/151] net: mscc: ocelot: fix VCAP filters remaining active after being deleted
Date:   Mon, 11 Oct 2021 15:45:42 +0200
Message-Id: <20211011134520.105539598@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 019d9329e7481cfaccbd8ed17b1e04ca76970f13 ]

When ocelot_flower.c calls ocelot_vcap_filter_add(), the filter has a
given filter->id.cookie. This filter is added to the block->rules list.

However, when ocelot_flower.c calls ocelot_vcap_block_find_filter_by_id()
which passes the cookie as argument, the filter is never found by
filter->id.cookie when searching through the block->rules list.

This is unsurprising, since the filter->id.cookie is an unsigned long,
but the cookie argument provided to ocelot_vcap_block_find_filter_by_id()
is a signed int, and the comparison fails.

Fixes: 50c6cc5b9283 ("net: mscc: ocelot: store a namespaced VCAP filter ID")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://lore.kernel.org/r/20210930125330.2078625-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_vcap.c | 4 ++--
 include/soc/mscc/ocelot_vcap.h          | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vcap.c b/drivers/net/ethernet/mscc/ocelot_vcap.c
index 7945393a0655..99d7376a70a7 100644
--- a/drivers/net/ethernet/mscc/ocelot_vcap.c
+++ b/drivers/net/ethernet/mscc/ocelot_vcap.c
@@ -998,8 +998,8 @@ ocelot_vcap_block_find_filter_by_index(struct ocelot_vcap_block *block,
 }
 
 struct ocelot_vcap_filter *
-ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int cookie,
-				    bool tc_offload)
+ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block,
+				    unsigned long cookie, bool tc_offload)
 {
 	struct ocelot_vcap_filter *filter;
 
diff --git a/include/soc/mscc/ocelot_vcap.h b/include/soc/mscc/ocelot_vcap.h
index 25fd525aaf92..4869ebbd438d 100644
--- a/include/soc/mscc/ocelot_vcap.h
+++ b/include/soc/mscc/ocelot_vcap.h
@@ -694,7 +694,7 @@ int ocelot_vcap_filter_add(struct ocelot *ocelot,
 int ocelot_vcap_filter_del(struct ocelot *ocelot,
 			   struct ocelot_vcap_filter *rule);
 struct ocelot_vcap_filter *
-ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block, int id,
-				    bool tc_offload);
+ocelot_vcap_block_find_filter_by_id(struct ocelot_vcap_block *block,
+				    unsigned long cookie, bool tc_offload);
 
 #endif /* _OCELOT_VCAP_H_ */
-- 
2.33.0



