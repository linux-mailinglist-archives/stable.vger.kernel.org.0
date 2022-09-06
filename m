Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22A8F5AEC75
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238741AbiIFOP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241898AbiIFOO1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:14:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA117F27D;
        Tue,  6 Sep 2022 06:49:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32D6DB818DC;
        Tue,  6 Sep 2022 13:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B23FC433C1;
        Tue,  6 Sep 2022 13:47:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472065;
        bh=VnqbKOhfd0RYEZrRMPOOEmKr2pH74nhg/CzblupPxyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M58sRB7JDbCEhJfoBog0+ax3i/dxVSA9DQMmTbXdZaDYMRPrUVUc76kpnJVqmVNYO
         Xb8R9B5G1icp9IrpQoQQOLl92SIXaF4e2snG5eswZeb2I7cDXNK7Bh6GfKiql317Sq
         +mrUXGshr4SXhnz++MBTurkKJz+Tx+tO8qoaa7lA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.19 105/155] thunderbolt: Use the actual buffer in tb_async_error()
Date:   Tue,  6 Sep 2022 15:30:53 +0200
Message-Id: <20220906132833.906197305@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit eb100b8fa8e8b59eb3e5fc7a5fd4a1e3c5950f64 upstream.

The received notification packet is held in pkg->buffer and not in pkg
itself. Fix this by using the correct buffer.

Fixes: 81a54b5e1986 ("thunderbolt: Let the connection manager handle all notifications")
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thunderbolt/ctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thunderbolt/ctl.c
+++ b/drivers/thunderbolt/ctl.c
@@ -407,7 +407,7 @@ static void tb_ctl_rx_submit(struct ctl_
 
 static int tb_async_error(const struct ctl_pkg *pkg)
 {
-	const struct cfg_error_pkg *error = (const struct cfg_error_pkg *)pkg;
+	const struct cfg_error_pkg *error = pkg->buffer;
 
 	if (pkg->frame.eof != TB_CFG_PKG_ERROR)
 		return false;


