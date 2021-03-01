Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320A232922A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238888AbhCAUkd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:40:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:49844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243585AbhCAUdi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:33:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 113E764F14;
        Mon,  1 Mar 2021 18:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622164;
        bh=FhAFLmwM6AvDOXjxWIIAupJmFYCg7bsnc/EYF2o4LeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iarBYFHGZHJl2Fur979bLRwv8PC4KdasVBvPmQRc8WPOfme6yIq4rwyxlEGTFsgW3
         o8uSe4qXKErg5ykRr9ukpUJX04IBdSVihb4EFUwZAZ2xzUaednFV59xeRCGCbfpFME
         Ee/wqjuX4RDnikQq3uI3BpdQx6lAaA4WA68zmC28=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nikos Tsironis <ntsironis@arrikto.com>,
        Ming-Hung Tsai <mtsai@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.11 764/775] dm era: Use correct value size in equality function of writeset tree
Date:   Mon,  1 Mar 2021 17:15:32 +0100
Message-Id: <20210301161239.067476921@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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


