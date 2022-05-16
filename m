Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8C48529179
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239712AbiEPUKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351032AbiEPUB4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539CD4756D;
        Mon, 16 May 2022 12:56:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F18D1B81614;
        Mon, 16 May 2022 19:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CCBAC385AA;
        Mon, 16 May 2022 19:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731015;
        bh=YEvJ+Z90ycumJC//xjiXZMSrJLry2O8DQ9GmHtH8Ezc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1PRq9D+MhfEkatl5TWO7P4ISkpXHkVwlnDCzvXlS+11U4/Fzc4wFnuAYMG+nnh2tD
         z0hku95xGV4LzdXW2ILJHY+Xa+8LsvcPXB5qmp/cuHvE/5f0rbFA70KA938jFmnJ+4
         kalcqGbv1HTb0SMokvjRwF1xc62rdXkGltswkgVs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Starke <daniel.starke@siemens.com>
Subject: [PATCH 5.17 076/114] tty: n_gsm: fix buffer over-read in gsm_dlci_data()
Date:   Mon, 16 May 2022 21:36:50 +0200
Message-Id: <20220516193627.669854974@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Starke <daniel.starke@siemens.com>

commit fd442e5ba30aaa75ea47b32149e7a3110dc20a46 upstream.

'len' is decreased after each octet that has its EA bit set to 0, which
means that the value is encoded with additional octets. However, the final
octet does not decreases 'len' which results in 'len' being one byte too
long. A buffer over-read may occur in tty_insert_flip_string() as it tries
to read one byte more than the passed content size of 'data'.
Decrease 'len' also for the final octet which has the EA bit set to 1 to
write the correct number of bytes from the internal receive buffer to the
virtual tty.

Fixes: 2e124b4a390c ("TTY: switch tty_flip_buffer_push")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Starke <daniel.starke@siemens.com>
Link: https://lore.kernel.org/r/20220504081733.3494-1-daniel.starke@siemens.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_gsm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1658,6 +1658,7 @@ static void gsm_dlci_data(struct gsm_dlc
 			if (len == 0)
 				return;
 		}
+		len--;
 		slen++;
 		tty = tty_port_tty_get(port);
 		if (tty) {


