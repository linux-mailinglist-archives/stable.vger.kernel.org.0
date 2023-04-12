Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C74C6DEF6D
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbjDLIuy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:50:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbjDLIuo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:50:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC4C9ED5
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:50:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6DF2D62A53
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8166EC4339C;
        Wed, 12 Apr 2023 08:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289383;
        bh=dpVJIteif6fRab4prIkffDFyzquENbtYNGrCWADgfpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kv3ztNB+N/UcvyKXGuuTRSg1cpEkJtV253SG2Iht8oKi4sYdEiRo9SJyzziTpN4qY
         9HiowPCzl6N7Ty/ff4GgszCk4JjFfSdUuzG4dNVUrjjhghnl09tzqerjjcbNj3YOqD
         0jeM1RVMZWLOZKLCQhphUWGGeeGuNzIN4U36dyaM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.2 078/173] iio: buffer: correctly return bytes written in output buffers
Date:   Wed, 12 Apr 2023 10:33:24 +0200
Message-Id: <20230412082841.212482522@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

commit b5184a26a28fac1d708b0bfeeb958a9260c2924c upstream.

If for some reason 'rb->access->write()' does not write the full
requested data and the O_NONBLOCK is set, we would return 'n' to
userspace which is not really truth. Hence, let's return the number of
bytes we effectively wrote.

Fixes: 9eeee3b0bf190 ("iio: Add output buffer support")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20230216101452.591805-2-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -220,7 +220,7 @@ static ssize_t iio_buffer_write(struct f
 	} while (ret == 0);
 	remove_wait_queue(&rb->pollq, &wait);
 
-	return ret < 0 ? ret : n;
+	return ret < 0 ? ret : written;
 }
 
 /**


