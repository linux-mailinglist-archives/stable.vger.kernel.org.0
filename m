Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 783D051AA10
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353168AbiEDRVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357980AbiEDRPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:15:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 753A456231;
        Wed,  4 May 2022 09:59:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56B2C6179D;
        Wed,  4 May 2022 16:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8229C385B0;
        Wed,  4 May 2022 16:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683551;
        bh=SukELfx7VYH3zBnpDxPY7eodkgYAyAGIELgmaM+bAN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dHIaQzqaMzpaT2PCiwT+wZ1Ohizs0qPtfEN/ZeIuJ/p2fIAJ+7E5EcPYqlpAHRORH
         QoEu5/FosRBzFrw6+flMVteJ5smw6TGT6TXXoBq8BZLRQ88/rNMgZ1iPQ5ZiMZ8XML
         OIdam6/O3Z3CWPGMVZn4Hj96iYXFbyvW6FuLZQjo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.17 205/225] tty: n_gsm: fix wrong signal octet encoding in convergence layer type 2
Date:   Wed,  4 May 2022 18:47:23 +0200
Message-Id: <20220504153128.393373915@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Daniel Starke <daniel.starke@siemens.com>

commit 06d5afd4d640eea67f5623e76cd5fc03359b7f3c upstream.

n_gsm is based on the 3GPP 07.010 and its newer version is the 3GPP 27.010.
See https://portal.3gpp.org/desktopmodules/Specifications/SpecificationDetails.aspx?specificationId=1516
The changes from 07.010 to 27.010 are non-functional. Therefore, I refer to
the newer 27.010 here. Chapter 5.5.2 describes that the signal octet in
convergence layer type 2 can be either one or two bytes. The length is
encoded in the EA bit. This is set 1 for the last byte in the sequence.
gsmtty_modem_update() handles this correctly but gsm_dlci_data_output()
fails to set EA to 1. There is no case in which we encode two signal octets
as there is no case in which we send out a break signal.
Therefore, always set the EA bit to 1 for the signal octet to fix this.

Fixes: e1eaea46bb40 ("tty: n_gsm line discipline")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220414094225.4527-5-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -832,7 +832,7 @@ static int gsm_dlci_data_output(struct g
 			break;
 		case 2:	/* Unstructed with modem bits.
 		Always one byte as we never send inline break data */
-			*dp++ = gsm_encode_modem(dlci);
+			*dp++ = (gsm_encode_modem(dlci) << 1) | EA;
 			break;
 		}
 		WARN_ON(kfifo_out_locked(&dlci->fifo, dp , len, &dlci->lock) != len);


