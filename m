Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61C9A4BDBB4
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349325AbiBUJ2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:28:48 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349320AbiBUJ1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:27:38 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 964B1237EB;
        Mon, 21 Feb 2022 01:12:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0D742CE0E7A;
        Mon, 21 Feb 2022 09:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E859CC340E9;
        Mon, 21 Feb 2022 09:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434766;
        bh=jFmCtWg6UXByFOjwBvpGW0pHoedNJ0St3LFtubUSk0I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K66vjMXorfdBU19W4YK7OTE8+rwVrIN/rngdVfxKvRnOHzqqDR1CzTY1OSnq0fzI9
         c6kdflDU7bkwkm0PG36SJkXvl2RRToeZiBFkjO9l0SxVViobNK7EWqTWXxzJowZmVp
         rfnUyt8WbKZm2eizGZQMoz242/mjRH+bidobeZrk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ruckajan10@gmail.com,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 124/196] smb3: fix snapshot mount option
Date:   Mon, 21 Feb 2022 09:49:16 +0100
Message-Id: <20220221084935.089323198@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steve French <stfrench@microsoft.com>

commit 9405b5f8b20c2bfa6523a555279a0379640dc136 upstream.

The conversion to the new API broke the snapshot mount option
due to 32 vs. 64 bit type mismatch

Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Cc: stable@vger.kernel.org # 5.11+
Reported-by: <ruckajan10@gmail.com>
Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/cifs/fs_context.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -146,7 +146,7 @@ const struct fs_parameter_spec smb3_fs_p
 	fsparam_u32("echo_interval", Opt_echo_interval),
 	fsparam_u32("max_credits", Opt_max_credits),
 	fsparam_u32("handletimeout", Opt_handletimeout),
-	fsparam_u32("snapshot", Opt_snapshot),
+	fsparam_u64("snapshot", Opt_snapshot),
 	fsparam_u32("max_channels", Opt_max_channels),
 
 	/* Mount options which take string value */
@@ -1062,7 +1062,7 @@ static int smb3_fs_context_parse_param(s
 		ctx->echo_interval = result.uint_32;
 		break;
 	case Opt_snapshot:
-		ctx->snapshot_time = result.uint_32;
+		ctx->snapshot_time = result.uint_64;
 		break;
 	case Opt_max_credits:
 		if (result.uint_32 < 20 || result.uint_32 > 60000) {


