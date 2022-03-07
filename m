Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F33774CF4E0
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:23:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235520AbiCGJYJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237305AbiCGJXm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:23:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 028A1264B;
        Mon,  7 Mar 2022 01:22:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B98D6B81054;
        Mon,  7 Mar 2022 09:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDC2C340E9;
        Mon,  7 Mar 2022 09:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646644945;
        bh=JmT9QfBOyZJcBBwWxnPYAC63NAd5BxcKK3R707o9fKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oKV2aksphvMiW+MSf2LMgWASp+L58l8lFJ3pS4DS2F6c7q7kCqxOR07BUVrdubhFr
         57Avw/fJOACLoedrLkYI5t/NTilMRCJSP6cQqODSlSuGl0AXCgMM9K1UNw4fR6nCUJ
         7xv259Cx5kHkU6fucSD032M5SN3xLJc5tY5zGg6k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 31/42] net: arcnet: com20020: Fix null-ptr-deref in com20020pci_probe()
Date:   Mon,  7 Mar 2022 10:19:05 +0100
Message-Id: <20220307091637.058914754@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091636.146155347@linuxfoundation.org>
References: <20220307091636.146155347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

commit bd6f1fd5d33dfe5d1b4f2502d3694a7cc13f166d upstream.

During driver initialization, the pointer of card info, i.e. the
variable 'ci' is required. However, the definition of
'com20020pci_id_table' reveals that this field is empty for some
devices, which will cause null pointer dereference when initializing
these devices.

The following log reveals it:

[    3.973806] KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
[    3.973819] RIP: 0010:com20020pci_probe+0x18d/0x13e0 [com20020_pci]
[    3.975181] Call Trace:
[    3.976208]  local_pci_probe+0x13f/0x210
[    3.977248]  pci_device_probe+0x34c/0x6d0
[    3.977255]  ? pci_uevent+0x470/0x470
[    3.978265]  really_probe+0x24c/0x8d0
[    3.978273]  __driver_probe_device+0x1b3/0x280
[    3.979288]  driver_probe_device+0x50/0x370

Fix this by checking whether the 'ci' is a null pointer first.

Fixes: 8c14f9c70327 ("ARCNET: add com20020 PCI IDs with metadata")
Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/arcnet/com20020-pci.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/arcnet/com20020-pci.c
+++ b/drivers/net/arcnet/com20020-pci.c
@@ -136,6 +136,9 @@ static int com20020pci_probe(struct pci_
 		return -ENOMEM;
 
 	ci = (struct com20020_pci_card_info *)id->driver_data;
+	if (!ci)
+		return -EINVAL;
+
 	priv->ci = ci;
 	mm = &ci->misc_map;
 


