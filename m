Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 906B459D34D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242314AbiHWIQq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242644AbiHWIPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:15:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57BED6D9F8;
        Tue, 23 Aug 2022 01:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D12E3B81C25;
        Tue, 23 Aug 2022 08:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16606C433D6;
        Tue, 23 Aug 2022 08:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242216;
        bh=GfvLHcQKa8EEuB0oS8LRPAOzkCWK28/qDxLgIRgfctY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U/SrVawcKMwVN7OfBIBL4magzQ3jAgX2JNoMLkX3UlilR/b9CKApyUaTiMVW/vnnh
         FHIppJ4S50saA+nsQRTFFxJt+FNWxZSq7Q6Bi88EC9HpAj1Ur754YQwuue1JXq8By/
         oaD3dLvAQAagN538i6AP0E5DfMeyNUno7KFieKRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason Wang" <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.19 078/365] virtio: VIRTIO_HARDEN_NOTIFICATION is broken
Date:   Tue, 23 Aug 2022 09:59:39 +0200
Message-Id: <20220823080121.453005696@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Michael S. Tsirkin <mst@redhat.com>

commit ebe797f25f68f28581f46a9cb9c1997ac15c39a0 upstream.

This option doesn't really work and breaks too many drivers.
Not yet sure what's the right thing to do, for now
let's make sure randconfig isn't broken by this.

Fixes: c346dae4f3fb ("virtio: disable notification hardening by default")
Cc: "Jason Wang" <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/virtio/Kconfig |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -35,11 +35,12 @@ if VIRTIO_MENU
 
 config VIRTIO_HARDEN_NOTIFICATION
         bool "Harden virtio notification"
+        depends on BROKEN
         help
           Enable this to harden the device notifications and suppress
           those that happen at a time where notifications are illegal.
 
-          Experimental: Note that several drivers still have bugs that
+          Experimental: Note that several drivers still have issues that
           may cause crashes or hangs when correct handling of
           notifications is enforced; depending on the subset of
           drivers and devices you use, this may or may not work.


