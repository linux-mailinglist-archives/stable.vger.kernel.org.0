Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3FCC9E199
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730943AbfH0H6K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 03:58:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730940AbfH0H6K (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:58:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A923217F5;
        Tue, 27 Aug 2019 07:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892689;
        bh=CKYGBamWBOWK2xoHlxxOJDpskW438wqkCT5TlLo9dj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ePRXt3hdghbgXN+r4VlIU/JktiKRCUJxPwOoPp2FnXLN4YpvdkQlTeVZAsCfVgPij
         J0/6VDhBtgJmRMmQpAMsT77X/sEDrSMtnA5V7CbBG2R06Sm/tuQ4QtV4zrWo3K8lIn
         /jO6LWJ60+G+LR7I+RZAEJP3N1esMSeL7G7s0X9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ZhangXiaoxu <zhangxiaoxu5@huawei.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 4.19 79/98] dm space map metadata: fix missing store of apply_bops() return value
Date:   Tue, 27 Aug 2019 09:50:58 +0200
Message-Id: <20190827072722.249767443@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ZhangXiaoxu <zhangxiaoxu5@huawei.com>

commit ae148243d3f0816b37477106c05a2ec7d5f32614 upstream.

In commit 6096d91af0b6 ("dm space map metadata: fix occasional leak
of a metadata block on resize"), we refactor the commit logic to a new
function 'apply_bops'.  But when that logic was replaced in out() the
return value was not stored.  This may lead out() returning a wrong
value to the caller.

Fixes: 6096d91af0b6 ("dm space map metadata: fix occasional leak of a metadata block on resize")
Cc: stable@vger.kernel.org
Signed-off-by: ZhangXiaoxu <zhangxiaoxu5@huawei.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/persistent-data/dm-space-map-metadata.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/persistent-data/dm-space-map-metadata.c
+++ b/drivers/md/persistent-data/dm-space-map-metadata.c
@@ -249,7 +249,7 @@ static int out(struct sm_metadata *smm)
 	}
 
 	if (smm->recursion_count == 1)
-		apply_bops(smm);
+		r = apply_bops(smm);
 
 	smm->recursion_count--;
 


