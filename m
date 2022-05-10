Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455F3521773
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242994AbiEJNZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242895AbiEJNZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:25:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39748369F7;
        Tue, 10 May 2022 06:17:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C987B61532;
        Tue, 10 May 2022 13:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C40D7C385C2;
        Tue, 10 May 2022 13:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188678;
        bh=uxmI1h5GXmIVI9bUbztyAkNTD9CthJs/xPqH/27qeR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J95VxAbe0b6rk4oW5vlu06uwiQQmZItEtggUaWnmK6raOUxXrxKMIIyKPWpprkNf6
         AvMLF3uaVuNfda8zCqvLx+g8i6uHBb8j8aqRbSVliPDn8Sp6CRAh6oIJ7UczxYS+aJ
         jOWC7ckgN6XMTLseO1phH7TWR5jCXHB8g9Tn0TMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 4.14 76/78] dm: interlock pending dm_io and dm_wait_for_bios_completion
Date:   Tue, 10 May 2022 15:08:02 +0200
Message-Id: <20220510130734.778375785@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.522479698@linuxfoundation.org>
References: <20220510130732.522479698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Snitzer <snitzer@redhat.com>

commit 9f6dc633761006f974701d4c88da71ab68670749 upstream.

Commit d208b89401e0 ("dm: fix mempool NULL pointer race when
completing IO") didn't go far enough.

When bio_end_io_acct ends the count of in-flight I/Os may reach zero
and the DM device may be suspended. There is a possibility that the
suspend races with dm_stats_account_io.

Fix this by adding percpu "pending_io" counters to track outstanding
dm_io. Move kicking of suspend queue to dm_io_dec_pending(). Also,
rename md_in_flight_bios() to dm_in_flight_bios() and update it to
iterate all pending_io counters.

Fixes: d208b89401e0 ("dm: fix mempool NULL pointer race when completing IO")
Cc: stable@vger.kernel.org
Co-developed-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2230,6 +2230,8 @@ static int dm_wait_for_completion(struct
 	}
 	finish_wait(&md->wait, &wait);
 
+	smp_rmb(); /* paired with atomic_dec_return in end_io_acct */
+
 	return r;
 }
 


