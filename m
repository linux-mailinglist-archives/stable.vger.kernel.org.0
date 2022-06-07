Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF2C5409D3
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:14:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350334AbiFGSOb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349083AbiFGSMy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:12:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC0D158955;
        Tue,  7 Jun 2022 10:48:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AE3BB8234F;
        Tue,  7 Jun 2022 17:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC844C385A5;
        Tue,  7 Jun 2022 17:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624134;
        bh=j/FHXUNXxbjTglfxsp6+7UF8NtOZAH48oMNxpP2zr5U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=izFe7LlTtZVTx6B6OCVafKKWuY+AwjfSIofgpYUYlRpO7qPO/RNcV5nxTJDhJjgTE
         lLg+nye3NWdFPDJKJdz4wqM9Uc1bavmC7noxME1iHYWWL4EaX1OhqySC4wG/xUSpv9
         PGnNEUkfktvKJ3AENb4VLgc44Afpn5mgdNjHgpZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Daniel Scally <djrscally@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 215/667] device property: Check fwnode->secondary when finding properties
Date:   Tue,  7 Jun 2022 18:58:00 +0200
Message-Id: <20220607164941.242849283@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Scally <djrscally@gmail.com>

[ Upstream commit c097af1d0a8483b44fa30e86b311991d76b6ae67 ]

fwnode_property_get_reference_args() searches for named properties
against a fwnode_handle, but these could instead be against the fwnode's
secondary. If the property isn't found against the primary, check the
secondary to see if it's there instead.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Daniel Scally <djrscally@gmail.com>
Link: https://lore.kernel.org/r/20211128232455.39332-1-djrscally@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/property.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 4c77837769c6..c29fa92be1fd 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -479,8 +479,17 @@ int fwnode_property_get_reference_args(const struct fwnode_handle *fwnode,
 				       unsigned int nargs, unsigned int index,
 				       struct fwnode_reference_args *args)
 {
-	return fwnode_call_int_op(fwnode, get_reference_args, prop, nargs_prop,
-				  nargs, index, args);
+	int ret;
+
+	ret = fwnode_call_int_op(fwnode, get_reference_args, prop, nargs_prop,
+				 nargs, index, args);
+
+	if (ret < 0 && !IS_ERR_OR_NULL(fwnode) &&
+	    !IS_ERR_OR_NULL(fwnode->secondary))
+		ret = fwnode_call_int_op(fwnode->secondary, get_reference_args,
+					 prop, nargs_prop, nargs, index, args);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(fwnode_property_get_reference_args);
 
-- 
2.35.1



