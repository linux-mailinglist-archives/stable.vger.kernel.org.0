Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8050048926D
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:46:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241422AbiAJHmf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240407AbiAJHgR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:36:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EEB1C028BFA;
        Sun,  9 Jan 2022 23:31:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F0ABB81204;
        Mon, 10 Jan 2022 07:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 638DEC36AE9;
        Mon, 10 Jan 2022 07:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799896;
        bh=lh3yShjx/46d/M0GAxDLwzAg5b4SKTEqcxr8exdbcr4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c4GFM0af7is7ryBngzeOVwQJnGgGEz9qwARo5TfW08ulHl6ItmbQOM7Db2LmonZo1
         alq6WgfVzulZvPRFrIuWuzbMVSLdcFWCbfrT96pYvDIRzph4frdahv6P7319LjcaBg
         cevMhsLZsDNY1IV6nn2fka/PcleDlkjAyjKzQkUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jeffrey E Altman <jaltman@auristor.com>
Subject: [PATCH 5.15 01/72] fscache_cookie_enabled: check cookie is valid before accessing it
Date:   Mon, 10 Jan 2022 08:22:38 +0100
Message-Id: <20220110071821.549570773@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071821.500480371@linuxfoundation.org>
References: <20220110071821.500480371@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dominique Martinet <asmadeus@codewreck.org>

commit 0dc54bd4d6e03be1f0b678c4297170b79f1a44ab upstream.

fscache_cookie_enabled() could be called on NULL cookies and cause a
null pointer dereference when accessing cookie flags: just make sure
the cookie is valid first

Suggested-by: David Howells <dhowells@redhat.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Cc: Jeffrey E Altman <jaltman@auristor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/fscache.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/fscache.h
+++ b/include/linux/fscache.h
@@ -167,7 +167,7 @@ struct fscache_cookie {
 
 static inline bool fscache_cookie_enabled(struct fscache_cookie *cookie)
 {
-	return test_bit(FSCACHE_COOKIE_ENABLED, &cookie->flags);
+	return fscache_cookie_valid(cookie) && test_bit(FSCACHE_COOKIE_ENABLED, &cookie->flags);
 }
 
 /*


