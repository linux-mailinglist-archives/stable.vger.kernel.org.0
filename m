Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB0C50F666
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241036AbiDZIr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346850AbiDZIp0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:45:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27ED8B3695;
        Tue, 26 Apr 2022 01:35:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B384D618E6;
        Tue, 26 Apr 2022 08:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A393C385A0;
        Tue, 26 Apr 2022 08:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962157;
        bh=KqzuKxuQJCdfP2D+y8yU6DtCUL++GH2XJYDjiu7Erv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FTtNvxAHpvdACfSnS5rEf2OPCH6N2B7mdfDfDhdKqZPZGF200w/Oyw539pC4/wKS8
         IpcXBzUR7IXx1L2cU15Sl6B5S29EV2CtrywmKuQTGgz/Z2eIk4i336sOrCtF5KBuOK
         eOfnIp79XtgqJ1vVo0a/YNDhwnJiPscud8WUJWt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, lee.jones@linaro.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "stable@vger.kernel.org, Dan Carpenter" <dan.carpenter@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 5.10 84/86] staging: ion: Prevent incorrect reference counting behavour
Date:   Tue, 26 Apr 2022 10:21:52 +0200
Message-Id: <20220426081743.639654235@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081741.202366502@linuxfoundation.org>
References: <20220426081741.202366502@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Supply additional check in order to prevent unexpected results.

Fixes: b892bf75b2034 ("ion: Switch ion to use dma-buf")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/android/ion/ion.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -114,6 +114,9 @@ static void *ion_buffer_kmap_get(struct
 	void *vaddr;
 
 	if (buffer->kmap_cnt) {
+		if (buffer->kmap_cnt == INT_MAX)
+			return ERR_PTR(-EOVERFLOW);
+
 		buffer->kmap_cnt++;
 		return buffer->vaddr;
 	}


