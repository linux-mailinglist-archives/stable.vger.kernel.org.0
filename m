Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7594855820B
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbiFWRJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234090AbiFWRIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:08:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB2855534F;
        Thu, 23 Jun 2022 09:57:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5DC05CE25DE;
        Thu, 23 Jun 2022 16:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D513C3411B;
        Thu, 23 Jun 2022 16:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003421;
        bh=o/jyu2ROdm31y2b8cgGf9XEmM2oEVHame+hPgu7jdd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s/659mShPveaWlfWI3+G09saMyth9PAPDPD7yU7GvSytw1szXvKc2pcgSupeCL6b0
         yHOeV9ogzTxfhf3IzZoxynqOfVgonH0LtslZycNfCuvTjBa9eyUm0EwIFxBQmjokst
         vXKC7cjDeGpauUzl2nwz5HAh2FMHvvZzTGfgzr4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, chengkaitao <pilgrimtao@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 233/264] virtio-mmio: fix missing put_device() when vm_cmdline_parent registration failed
Date:   Thu, 23 Jun 2022 18:43:46 +0200
Message-Id: <20220623164350.670172215@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: chengkaitao <pilgrimtao@gmail.com>

[ Upstream commit a58a7f97ba11391d2d0d408e0b24f38d86ae748e ]

The reference must be released when device_register(&vm_cmdline_parent)
failed. Add the corresponding 'put_device()' in the error handling path.

Signed-off-by: chengkaitao <pilgrimtao@gmail.com>
Message-Id: <20220602005542.16489-1-chengkaitao@didiglobal.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_mmio.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 50840984fbfa..f62da3b7c27b 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -630,6 +630,7 @@ static int vm_cmdline_set(const char *device,
 	if (!vm_cmdline_parent_registered) {
 		err = device_register(&vm_cmdline_parent);
 		if (err) {
+			put_device(&vm_cmdline_parent);
 			pr_err("Failed to register parent device!\n");
 			return err;
 		}
-- 
2.35.1



