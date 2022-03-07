Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28D934CFA17
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiCGKNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242809AbiCGKLy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:11:54 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10758BF5D;
        Mon,  7 Mar 2022 01:55:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 05633CE0E4A;
        Mon,  7 Mar 2022 09:55:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE630C340E9;
        Mon,  7 Mar 2022 09:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646956;
        bh=gW6078TtMBc0nG9JtxZimbvAuZygoi9s6gkAltK/iRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OISmabbhWSVTtTw3XSFf/2W4KTpBCPZ+RYmZZX5ypsIvUWfMOzyrEm0EUGnTu3DNa
         Qv+l8N82fMjT5uLNeJ+QqVtLfYJVMin4D4nqmFvNEwY0gOtOsmpYm++Z53PHMNCCZQ
         XMYHxreUEzOdyP6MI2AaOMAX6rpgoOwFpNQuLRDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        linux-mips@vger.kernel.org
Subject: [PATCH 5.16 109/186] mips: setup: fix setnocoherentio() boolean setting
Date:   Mon,  7 Mar 2022 10:19:07 +0100
Message-Id: <20220307091657.125939337@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091654.092878898@linuxfoundation.org>
References: <20220307091654.092878898@linuxfoundation.org>
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

From: Randy Dunlap <rdunlap@infradead.org>

commit 1e6ae0e46e32749b130f1823da30cea9aa2a59a0 upstream.

Correct a typo/pasto: setnocoherentio() should set
dma_default_coherent to false, not true.

Fixes: 14ac09a65e19 ("MIPS: refactor the runtime coherent vs noncoherent DMA indicators")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/kernel/setup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/kernel/setup.c
+++ b/arch/mips/kernel/setup.c
@@ -803,7 +803,7 @@ early_param("coherentio", setcoherentio)
 
 static int __init setnocoherentio(char *str)
 {
-	dma_default_coherent = true;
+	dma_default_coherent = false;
 	pr_info("Software DMA cache coherency (command line)\n");
 	return 0;
 }


