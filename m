Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EF5C5B51B8
	for <lists+stable@lfdr.de>; Mon, 12 Sep 2022 01:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiIKXBF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Sep 2022 19:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIKXBE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Sep 2022 19:01:04 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC6A22BC3;
        Sun, 11 Sep 2022 16:01:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9E5F41F983;
        Sun, 11 Sep 2022 23:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1662937259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6GyFucV8IpoFY7ympxLT3VA1hGgSyrlaYbBgNDtngws=;
        b=AapnVKz9c6auorp4kIOp+Di5TmReoXni7sRNu0PSMenZJjKKcJaR5+mOTSAY2lqRZzH5Yw
        iCj+9I1nZFGzdnwJZkn5+wNNKhaQ4MN6adAhTgaWpQ72ese3u1Z45kAFn0y3M286vQyqbb
        KfsKILXMAFrPnJUi7VsaUurDbjjFXHM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1662937259;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6GyFucV8IpoFY7ympxLT3VA1hGgSyrlaYbBgNDtngws=;
        b=drju+b++gNLD/clfcCSu/WZXKkgAPKWSEVYI0oc3rTF6Zbb2Ix33AW1MPpGdvG6k9CUK4p
        KfviLz7Unw5tibCQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 27A3F133E6;
        Sun, 11 Sep 2022 23:00:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7DwFM6hoHmPhDgAAMHmgww
        (envelope-from <neilb@suse.de>); Sun, 11 Sep 2022 23:00:56 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     "Eugeniu Rosca" <erosca@de.adit-jv.com>,
        "Trond Myklebust" <trondmy@hammerspace.com>,
        "mrodin@de.adit-jv.com" <mrodin@de.adit-jv.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "roscaeugeniu@gmail.com" <roscaeugeniu@gmail.com>
Subject: [PATCH - stable] SUNRPC: use _bh spinlocking on ->transport_lock
In-reply-to: <Yx107owrRwmIc7pX@kroah.com>
References: <20220418121210.689577360@linuxfoundation.org>,
 <20220418121211.327937970@linuxfoundation.org>,
 <20220907142548.GA9975@lxhi-065>,
 <166259870333.30452.4204968221881228505@noble.neil.brown.name>,
 <f575eeb3000330d9194c6256ad6063bc58f996c7.camel@hammerspace.com>,
 <20220908120931.GA3480@lxhi-065>, <Yx107owrRwmIc7pX@kroah.com>
Date:   Mon, 12 Sep 2022 09:00:52 +1000
Message-id: <166293725263.30452.1720462103844620549@noble.neil.brown.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Prior to Linux 5.3, ->transport_lock in sunrpc required the _bh style
spinlocks (when not called from a bottom-half handler).

When upstream 3848e96edf4788f772d83990022fa7023a233d83 was backported to
stable kernels, the spin_lock/unlock calls should have been changed to
the _bh version, but this wasn't noted in the patch and didn't happen.

So convert these lock/unlock calls to the _bh versions.

This patch is required for any stable kernel prior to 5.3 to which the
above mentioned patch was backported.  Namely 4.9.y, 4.14.y, 4.19.y.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 net/sunrpc/xprt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index d05fa7c36d00..b1abf4848bbc 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -1550,9 +1550,9 @@ static void xprt_destroy(struct rpc_xprt *xprt)
 	 * is cleared.  We use ->transport_lock to ensure the mod_timer()
 	 * can only run *before* del_time_sync(), never after.
 	 */
-	spin_lock(&xprt->transport_lock);
+	spin_lock_bh(&xprt->transport_lock);
 	del_timer_sync(&xprt->timer);
-	spin_unlock(&xprt->transport_lock);
+	spin_unlock_bh(&xprt->transport_lock);
 
 	/*
 	 * Destroy sockets etc from the system workqueue so they can
-- 
2.37.1

