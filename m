Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7F05360F4
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 14:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352264AbiE0L6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:58:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353221AbiE0L4T (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:56:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42BC613C0B3;
        Fri, 27 May 2022 04:50:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4ADF61D56;
        Fri, 27 May 2022 11:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFF55C385A9;
        Fri, 27 May 2022 11:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653652208;
        bh=0gBkQ6wLl5EpKBmIFvV+KeU4l2koaTdbhqt98TGAaLc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJtQAgOK/fyzIOik7BNLLoEJ9otQLTYJEcEaz5+MIthFc8HmXL9nlBzUWS7EFwS5e
         DMCAQbpEh5ZMaWS1913DEYpMMeTgwsjnDcmrLEMZcHc56wQr79tLsIGbpd/dpLazKT
         JSd/jsoleSIRR98KrrPSYQHlWd2g4/i6Q/bu4bpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 111/163] random: re-add removed comment about get_random_{u32,u64} reseeding
Date:   Fri, 27 May 2022 10:49:51 +0200
Message-Id: <20220527084843.612366451@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit dd7aa36e535797926d8eb311da7151919130139d upstream.

The comment about get_random_{u32,u64}() not invoking reseeding got
added in an unrelated commit, that then was recently reverted by
0313bc278dac ("Revert "random: block in /dev/urandom""). So this adds
that little comment snippet back, and improves the wording a bit too.

Reviewed-by: Dominik Brodowski <linux@dominikbrodowski.net>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -226,9 +226,10 @@ static void _warn_unseeded_randomness(co
  *
  * These interfaces will return the requested number of random bytes
  * into the given buffer or as a return value. This is equivalent to
- * a read from /dev/urandom. The integer family of functions may be
- * higher performance for one-off random integers, because they do a
- * bit of buffering.
+ * a read from /dev/urandom. The u32, u64, int, and long family of
+ * functions may be higher performance for one-off random integers,
+ * because they do a bit of buffering and do not invoke reseeding
+ * until the buffer is emptied.
  *
  *********************************************************************/
 


