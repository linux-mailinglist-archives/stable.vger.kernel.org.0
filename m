Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6BB75AE9F7
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240657AbiIFNh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240658AbiIFNg1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:36:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C013A8;
        Tue,  6 Sep 2022 06:34:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9105B8162F;
        Tue,  6 Sep 2022 13:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7CDC433C1;
        Tue,  6 Sep 2022 13:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471259;
        bh=VY3oNhA7IZj58Y+dGVC/lEo2kbWgI1BhCbuVBbof5wI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HIXWKGa9xskNJUdp8OwyNt0m8DjwyZqWpDd7oC82QUWWIPzPUZDGS+hw4c6J4roOp
         HEsBE4cEDI25ZpaIHvDIdd1t+EviObkjwQgDBd9KgcUFO3AUWsvBeATxBzOnRknnsP
         9CsgqShP/Ni/DzB2Zx/eK1VVV8o6AzTS1qJ7uwMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.10 49/80] thunderbolt: Use the actual buffer in tb_async_error()
Date:   Tue,  6 Sep 2022 15:30:46 +0200
Message-Id: <20220906132819.055658212@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
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
@@ -396,7 +396,7 @@ static void tb_ctl_rx_submit(struct ctl_
 
 static int tb_async_error(const struct ctl_pkg *pkg)
 {
-	const struct cfg_error_pkg *error = (const struct cfg_error_pkg *)pkg;
+	const struct cfg_error_pkg *error = pkg->buffer;
 
 	if (pkg->frame.eof != TB_CFG_PKG_ERROR)
 		return false;


