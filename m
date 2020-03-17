Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE8E187FB5
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgCQLDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:03:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728201AbgCQLDz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:03:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F3C220736;
        Tue, 17 Mar 2020 11:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443034;
        bh=51yulXfNqWebYz/Y5VuAdOufMoLUdCW4U1+oHKowC/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MmZWrTC/qNx91TofkwyNTE9cQfmG9nHtzczjI3QnGOW7/vZTj+/dNvdBRhdS9LsfA
         vmYSUkz/pwVMIYo59LbB6QclO0BKMo2OUfLs1YCILzl8f1BahxEjhs2oaUJbOO6Vuc
         qBmFiEezQ/TO28HyRdMd5MkGc3g3/tqPquTtVdYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 036/123] devlink: validate length of param values
Date:   Tue, 17 Mar 2020 11:54:23 +0100
Message-Id: <20200317103311.592294668@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103307.343627747@linuxfoundation.org>
References: <20200317103307.343627747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 8750939b6ad86abc3f53ec8a9683a1cded4a5654 ]

DEVLINK_ATTR_PARAM_VALUE_DATA may have different types
so it's not checked by the normal netlink policy. Make
sure the attribute length is what we expect.

Fixes: e3b7ca18ad7b ("devlink: Add param set command")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/devlink.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

--- a/net/core/devlink.c
+++ b/net/core/devlink.c
@@ -3222,34 +3222,41 @@ devlink_param_value_get_from_info(const
 				  struct genl_info *info,
 				  union devlink_param_value *value)
 {
+	struct nlattr *param_data;
 	int len;
 
-	if (param->type != DEVLINK_PARAM_TYPE_BOOL &&
-	    !info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA])
+	param_data = info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA];
+
+	if (param->type != DEVLINK_PARAM_TYPE_BOOL && !param_data)
 		return -EINVAL;
 
 	switch (param->type) {
 	case DEVLINK_PARAM_TYPE_U8:
-		value->vu8 = nla_get_u8(info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA]);
+		if (nla_len(param_data) != sizeof(u8))
+			return -EINVAL;
+		value->vu8 = nla_get_u8(param_data);
 		break;
 	case DEVLINK_PARAM_TYPE_U16:
-		value->vu16 = nla_get_u16(info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA]);
+		if (nla_len(param_data) != sizeof(u16))
+			return -EINVAL;
+		value->vu16 = nla_get_u16(param_data);
 		break;
 	case DEVLINK_PARAM_TYPE_U32:
-		value->vu32 = nla_get_u32(info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA]);
+		if (nla_len(param_data) != sizeof(u32))
+			return -EINVAL;
+		value->vu32 = nla_get_u32(param_data);
 		break;
 	case DEVLINK_PARAM_TYPE_STRING:
-		len = strnlen(nla_data(info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA]),
-			      nla_len(info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA]));
-		if (len == nla_len(info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA]) ||
+		len = strnlen(nla_data(param_data), nla_len(param_data));
+		if (len == nla_len(param_data) ||
 		    len >= __DEVLINK_PARAM_MAX_STRING_VALUE)
 			return -EINVAL;
-		strcpy(value->vstr,
-		       nla_data(info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA]));
+		strcpy(value->vstr, nla_data(param_data));
 		break;
 	case DEVLINK_PARAM_TYPE_BOOL:
-		value->vbool = info->attrs[DEVLINK_ATTR_PARAM_VALUE_DATA] ?
-			       true : false;
+		if (param_data && nla_len(param_data))
+			return -EINVAL;
+		value->vbool = nla_get_flag(param_data);
 		break;
 	}
 	return 0;


