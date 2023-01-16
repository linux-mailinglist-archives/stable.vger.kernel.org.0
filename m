Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76D4466C8AF
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbjAPQl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:41:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233544AbjAPQlL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:41:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15C7D36FC6
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:29:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D80E061077
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA126C433EF;
        Mon, 16 Jan 2023 16:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886570;
        bh=RasDkXRFi84a4c6TvGJDhFvdAMwpujcclByER8bQ844=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NJLXcu3ASt16rqZI05HxkfC0vBSFcuou4mYl2PeYeGmgKZlKbFDkARXCOJQzdTag+
         QSiQ85TanTC0iINjcOAdRieWnQu7cdRi5z/sR4RYQsylP3Eo0l/fpXK0cT4+3A2Lc7
         nwwuQS6VnrQUo2WGIvBbzoNyOZ/0fScV9XxDNw64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Stephen Rothwell" <sfr@canb.auug.org.au>,
        Lin Ma <linma@zju.edu.cn>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 5.4 451/658] media: dvbdev: fix build warning due to comments
Date:   Mon, 16 Jan 2023 16:48:59 +0100
Message-Id: <20230116154930.119274898@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lin Ma <linma@zju.edu.cn>

commit 3edfd14bb50fa6f94ed1a37bbb17d9f1c2793b57 upstream.

Previous commit that introduces reference counter does not add proper
comments, which will lead to warning when building htmldocs. Fix them.

Reported-by: "Stephen Rothwell" <sfr@canb.auug.org.au>
Fixes: 0fc044b2b5e2 ("media: dvbdev: adopts refcnt to avoid UAF")
Signed-off-by: Lin Ma <linma@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/media/dvbdev.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/media/dvbdev.h
+++ b/include/media/dvbdev.h
@@ -126,6 +126,7 @@ struct dvb_adapter {
  * struct dvb_device - represents a DVB device node
  *
  * @list_head:	List head with all DVB devices
+ * @ref:	reference counter
  * @fops:	pointer to struct file_operations
  * @adapter:	pointer to the adapter that holds this device node
  * @type:	type of the device, as defined by &enum dvb_device_type.
@@ -196,7 +197,7 @@ struct dvb_device {
 struct dvb_device *dvb_device_get(struct dvb_device *dvbdev);
 
 /**
- * dvb_device_get - Decrease dvb_device reference
+ * dvb_device_put - Decrease dvb_device reference
  *
  * @dvbdev:	pointer to struct dvb_device
  */


