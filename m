Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F43D3284BD
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbhCAQmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:42:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:41980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232124AbhCAQfX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:35:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBC9364F6E;
        Mon,  1 Mar 2021 16:26:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615967;
        bh=FhAFLmwM6AvDOXjxWIIAupJmFYCg7bsnc/EYF2o4LeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oiIY7IAuTdm7EznTU96MGWSUGmgG1zPRqY1r3vyJiQgDy+52illEDIu414pBuH/2q
         A3Nn25OKS7H3taAp5vF3aXiuBIEczPozsHccPhzsY94aHOqQXOKBtHuDZbxKLY+SBd
         +ztcto42Af2jHK7/jNzUd2BgxHrK1kVuqJp5oRDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Ming-Hung Tsai <mtsai@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.9 123/134] dm era: Use correct value size in equality function of writeset tree
Date:   Mon,  1 Mar 2021 17:13:44 +0100
Message-Id: <20210301161019.636131504@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikos Tsironis <ntsironis@arrikto.com>

commit 64f2d15afe7b336aafebdcd14cc835ecf856df4b upstream.

Fix the writeset tree equality test function to use the right value size
when comparing two btree values.

Fixes: eec40579d84873 ("dm: add era target")
Cc: stable@vger.kernel.org # v3.15+
Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
Reviewed-by: Ming-Hung Tsai <mtsai@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-era-target.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -389,7 +389,7 @@ static void ws_dec(void *context, const
 
 static int ws_eq(void *context, const void *value1, const void *value2)
 {
-	return !memcmp(value1, value2, sizeof(struct writeset_metadata));
+	return !memcmp(value1, value2, sizeof(struct writeset_disk));
 }
 
 /*----------------------------------------------------------------*/


