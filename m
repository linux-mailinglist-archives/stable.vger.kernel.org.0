Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C95C95486E9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354742AbiFMMRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353382AbiFMMP7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:15:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CC455210;
        Mon, 13 Jun 2022 04:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D5FD0B80E93;
        Mon, 13 Jun 2022 11:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4293FC3411E;
        Mon, 13 Jun 2022 11:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118147;
        bh=erIyMVOhyoEFSBOTr7ERMzU5x1lpDP/dtyEg2fpINQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EVNlFVrCKZPCP6qXpiQVrwBJtaB1GmRe2nB2ulOyRBzZ1PxkMlsru670j7Xl2niWK
         hsUsaC1lnetiLkrB8BIZ0LxtOW83Lr4+xMl4P+mCrDQ/jIfdF6s8PpIGKQNnOG739I
         cc9dJBoq1xvn8yRR5VER7GkjbuukgHCApag1//Fw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 259/287] misc: rtsx: set NULL intfdata when probe fails
Date:   Mon, 13 Jun 2022 12:11:23 +0200
Message-Id: <20220613094931.862633754@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit f861d36e021e1ac4a0a2a1f6411d623809975d63 ]

rtsx_usb_probe() doesn't call usb_set_intfdata() to null out the
interface pointer when probe fails. This leaves a stale pointer.
Noticed the missing usb_set_intfdata() while debugging an unrelated
invalid DMA mapping problem.

Fix it with a call to usb_set_intfdata(..., NULL).

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20220429210913.46804-1-skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/cardreader/rtsx_usb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/misc/cardreader/rtsx_usb.c b/drivers/misc/cardreader/rtsx_usb.c
index b97903ff1a72..869c176d48cc 100644
--- a/drivers/misc/cardreader/rtsx_usb.c
+++ b/drivers/misc/cardreader/rtsx_usb.c
@@ -678,6 +678,7 @@ static int rtsx_usb_probe(struct usb_interface *intf,
 	return 0;
 
 out_init_fail:
+	usb_set_intfdata(ucr->pusb_intf, NULL);
 	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
 			ucr->iobuf_dma);
 	return ret;
-- 
2.35.1



