Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D839A615AEF
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbiKBDoV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230216AbiKBDoT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:44:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E3CB26F0
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:44:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFBB561799
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:44:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CE03C433C1;
        Wed,  2 Nov 2022 03:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667360658;
        bh=JjeIzlE8eQaGHGfa3JuPbJB+POP7qOf0td7u3hlJGZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EQaQn3qovEi7DAprFYo80TpY18ECWzWB/G+LXPl2JNce9T+vxl+bMze687tNLJ9c1
         BBnZUb9rANdPoPkKrJdZ/8MERfP6CXyq8Z3obKKyRiQeJOiASbLuniE0phdMEo0WEm
         Sua9QW/A9tSX22RHsJTqLLWstVHo+Wa/zLP01LsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Matti Vaittinen <mazziesaccount@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.9 15/44] tools: iio: iio_utils: fix digit calculation
Date:   Wed,  2 Nov 2022 03:35:01 +0100
Message-Id: <20221102022049.577864024@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022049.017479464@linuxfoundation.org>
References: <20221102022049.017479464@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matti Vaittinen <mazziesaccount@gmail.com>

commit 72b2aa38191bcba28389b0e20bf6b4f15017ff2b upstream.

The iio_utils uses a digit calculation in order to know length of the
file name containing a buffer number. The digit calculation does not
work for number 0.

This leads to allocation of one character too small buffer for the
file-name when file name contains value '0'. (Eg. buffer0).

Fix digit calculation by returning one digit to be present for number
'0'.

Fixes: 096f9b862e60 ("tools:iio:iio_utils: implement digit calculation")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://lore.kernel.org/r/Y0f+tKCz+ZAIoroQ@dc75zzyyyyyyyyyyyyycy-3.rev.dnainternet.fi
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/iio/iio_utils.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/tools/iio/iio_utils.c
+++ b/tools/iio/iio_utils.c
@@ -546,6 +546,10 @@ static int calc_digits(int num)
 {
 	int count = 0;
 
+	/* It takes a digit to represent zero */
+	if (!num)
+		return 1;
+
 	while (num != 0) {
 		num /= 10;
 		count++;


