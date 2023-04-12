Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0191D6DEF62
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231319AbjDLIuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231382AbjDLIuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:50:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F2A9ECC
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:49:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 633206313B
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:49:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A388C433EF;
        Wed, 12 Apr 2023 08:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289386;
        bh=lxjy0herTY3nPIjIN7MHtjRmv7Ula2S2rl7YYIm7pzw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rTx4gIrzjHAztc20IR40SdR4xdxiXMH8HAVS61sMiW0NlEtVH16wQ3rJzyD9qe12O
         IKECnFpbn45CYQeR2aqYRRuPGyXeK9LEhf9bzNVbrqNKHuXaDzBpZsiJXLaP7chGXf
         KbX+PX6ATVWA+vzBHZSAtHdkzJeyKgI3VudZQX5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Lars-Peter Clausen <lars@metafoo.de>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.2 079/173] iio: buffer: make sure O_NONBLOCK is respected
Date:   Wed, 12 Apr 2023 10:33:25 +0200
Message-Id: <20230412082841.251538433@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nuno Sá <nuno.sa@analog.com>

commit 3da1814184582ed0faf039275a3f02e6f69944ee upstream.

For output buffers, there's no guarantee that the buffer won't be full
in the first iteration of the loop in which case we would block
independently of userspace passing O_NONBLOCK or not. Fix it by always
checking the flag before going to sleep.

While at it (and as it's a bit related), refactored the loop so that the
stop condition is 'written != n', i.e, run the loop until all data has
been copied into the IIO buffers. This makes the code a bit simpler.

Fixes: 9eeee3b0bf190 ("iio: Add output buffer support")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20230216101452.591805-3-nuno.sa@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-buffer.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -203,21 +203,24 @@ static ssize_t iio_buffer_write(struct f
 				break;
 			}
 
+			if (filp->f_flags & O_NONBLOCK) {
+				if (!written)
+					ret = -EAGAIN;
+				break;
+			}
+
 			wait_woken(&wait, TASK_INTERRUPTIBLE,
 					MAX_SCHEDULE_TIMEOUT);
 			continue;
 		}
 
 		ret = rb->access->write(rb, n - written, buf + written);
-		if (ret == 0 && (filp->f_flags & O_NONBLOCK))
-			ret = -EAGAIN;
+		if (ret < 0)
+			break;
 
-		if (ret > 0) {
-			written += ret;
-			if (written != n && !(filp->f_flags & O_NONBLOCK))
-				continue;
-		}
-	} while (ret == 0);
+		written += ret;
+
+	} while (written != n);
 	remove_wait_queue(&rb->pollq, &wait);
 
 	return ret < 0 ? ret : written;


