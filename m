Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D38A5AEB2F
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239432AbiIFNzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239629AbiIFNyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:54:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20CCD8053E;
        Tue,  6 Sep 2022 06:40:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C1DE761552;
        Tue,  6 Sep 2022 13:40:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF07EC433C1;
        Tue,  6 Sep 2022 13:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471645;
        bh=1Grr6cRkWMNTuRQ3stK+Ukn+lxxXvUVWfTjVS8pcPo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gfJhITUDy0R0q3HryLNqPJjp6Ky/3ui8SCfGVEgtvbhgjlmiqs0X0Sg8BMxXz1ftz
         9RYsBcBcjefXBSyBNKjUeiyDS+QfR42adARiwxopAtEVhmgSuZcwSmFDJIdVPT7yuh
         QSWo78eYeBMUnEvFD/4htWwhWL1xq0As1AiHlhAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.15 067/107] thunderbolt: Use the actual buffer in tb_async_error()
Date:   Tue,  6 Sep 2022 15:30:48 +0200
Message-Id: <20220906132824.656312788@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
References: <20220906132821.713989422@linuxfoundation.org>
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
@@ -408,7 +408,7 @@ static void tb_ctl_rx_submit(struct ctl_
 
 static int tb_async_error(const struct ctl_pkg *pkg)
 {
-	const struct cfg_error_pkg *error = (const struct cfg_error_pkg *)pkg;
+	const struct cfg_error_pkg *error = pkg->buffer;
 
 	if (pkg->frame.eof != TB_CFG_PKG_ERROR)
 		return false;


