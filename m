Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B22064A242
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232797AbiLLNwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:52:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbiLLNv3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:51:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E41B8140E0
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:50:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9960AB80B78
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:50:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42ECC433D2;
        Mon, 12 Dec 2022 13:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670853044;
        bh=55LRY2CZ6QAmnSz7+2cnqjbDvw0PzXkBfwFtJwW8dqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L8MtzYm2SKzxbmgXEeHN7HeorGUJgn/YqDg2Ig8TYz6kgguZV/uLGGI3SlW40dc8n
         j5UohZOvhVVdaVGXYaRLRxu4jyQS5vI9JvbqLvTebu+UP2BFQW0MTi8aPct07b9rN/
         n5lKEASu76b+mQ5nbiNogOTKLV7Idwl8T2Jvf4tE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Anastasia Belova <abelova@astralinux.ru>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 20/49] HID: hid-lg4ff: Add check for empty lbuf
Date:   Mon, 12 Dec 2022 14:18:58 +0100
Message-Id: <20221212130914.701449554@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130913.666185567@linuxfoundation.org>
References: <20221212130913.666185567@linuxfoundation.org>
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

From: Anastasia Belova <abelova@astralinux.ru>

commit d180b6496143cd360c5d5f58ae4b9a8229c1f344 upstream.

If an empty buf is received, lbuf is also empty. So lbuf is
accessed by index -1.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: f31a2de3fe36 ("HID: hid-lg4ff: Allow switching of Logitech gaming wheels between compatibility modes")
Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-lg4ff.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hid/hid-lg4ff.c
+++ b/drivers/hid/hid-lg4ff.c
@@ -878,6 +878,12 @@ static ssize_t lg4ff_alternate_modes_sto
 		return -ENOMEM;
 
 	i = strlen(lbuf);
+
+	if (i == 0) {
+		kfree(lbuf);
+		return -EINVAL;
+	}
+
 	if (lbuf[i-1] == '\n') {
 		if (i == 1) {
 			kfree(lbuf);


