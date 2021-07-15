Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A45023CAAC7
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 21:13:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242544AbhGOTPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 15:15:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:51090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244286AbhGOTOk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 15:14:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3000C613DA;
        Thu, 15 Jul 2021 19:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626376201;
        bh=+Lx/Ybu2Aq/kX7lL1Obv6xgjVcG9zJEyTOFHv8wmvHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=igv0TmwMCz5B7fX/vHm2LuMg60yivJqPnpAIJ+LEUlUCQ6bYLkgqHQOrhovSeKnnd
         z4IHVcptXAOe9LupmW5YIrVjL3jGgUPcdjTUsSzruwBadgzJLMtl9egyJpnuHQVvlh
         6V7AUobEPQRdJQU0DdIOrdI2HahZp9nuBJrdjDeU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, gushengxian <13145886936@163.com>,
        gushengxian <gushengxian@yulong.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 171/266] flow_offload: action should not be NULL when it is referenced
Date:   Thu, 15 Jul 2021 20:38:46 +0200
Message-Id: <20210715182642.443757130@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182613.933608881@linuxfoundation.org>
References: <20210715182613.933608881@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

[ Upstream commit 9ea3e52c5bc8bb4a084938dc1e3160643438927a ]

"action" should not be NULL when it is referenced.

Signed-off-by: gushengxian <13145886936@163.com>
Signed-off-by: gushengxian <gushengxian@yulong.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/flow_offload.h | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index dc5c1e69cd9f..69c9eabf8325 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -319,12 +319,14 @@ flow_action_mixed_hw_stats_check(const struct flow_action *action,
 	if (flow_offload_has_one_action(action))
 		return true;
 
-	flow_action_for_each(i, action_entry, action) {
-		if (i && action_entry->hw_stats != last_hw_stats) {
-			NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
-			return false;
+	if (action) {
+		flow_action_for_each(i, action_entry, action) {
+			if (i && action_entry->hw_stats != last_hw_stats) {
+				NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
+				return false;
+			}
+			last_hw_stats = action_entry->hw_stats;
 		}
-		last_hw_stats = action_entry->hw_stats;
 	}
 	return true;
 }
-- 
2.30.2



