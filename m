Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9786924B2E5
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726749AbgHTJik (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:38:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728867AbgHTJih (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:38:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 813E920724;
        Thu, 20 Aug 2020 09:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916317;
        bh=yLpcs7nLt1ItWDLK/1O1qK6gtIEVmxM/EWbIXoZQufA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q03+gX1+dhhX3yP6TKxm18Zo4mxSJG3OE4z//oKfgI4cb+o67tlDJ7PgxkSY22uZ8
         CNiS8JNjq55KA9iY143zJ7BCF0+buxKA3tf44UB93MWVn0J3sp1KoQEJjjfzxcjdyq
         vPPSgSqKCpr+xRwqKaqxA9udQzbvMwK/QQWCyFGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.7 086/204] dm: dont call report zones for more than the user requested
Date:   Thu, 20 Aug 2020 11:19:43 +0200
Message-Id: <20200820091610.633981297@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

commit a9cb9f4148ef6bb8fabbdaa85c42b2171fbd5a0d upstream.

Don't call report zones for more zones than the user actually requested,
otherwise this can lead to out-of-bounds accesses in the callback
functions.

Such a situation can happen if the target's ->report_zones() callback
function returns 0 because we've reached the end of the target and then
restart the report zones on the second target.

We're again calling into ->report_zones() and ultimately into the user
supplied callback function but when we're not subtracting the number of
zones already processed this may lead to out-of-bounds accesses in the
user callbacks.

Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Fixes: d41003513e61 ("block: rework zone reporting")
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -503,7 +503,8 @@ static int dm_blk_report_zones(struct ge
 		}
 
 		args.tgt = tgt;
-		ret = tgt->type->report_zones(tgt, &args, nr_zones);
+		ret = tgt->type->report_zones(tgt, &args,
+					      nr_zones - args.zone_idx);
 		if (ret < 0)
 			goto out;
 	} while (args.zone_idx < nr_zones &&


