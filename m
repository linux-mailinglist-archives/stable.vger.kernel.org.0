Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D28C9E0C8
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730896AbfH0IGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:06:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:35956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728415AbfH0IGA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:06:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96D0D206BF;
        Tue, 27 Aug 2019 08:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893160;
        bh=CKYGBamWBOWK2xoHlxxOJDpskW438wqkCT5TlLo9dj0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oXDIeffGsTrr7zrpM6kM/EtJdKm//5pVCmVRSQl+pgGIr6K1JNUWHFHxtlhZE30GI
         YwT7i+D2mPLXkGW/7aK9ccybvPkgXzQvn7iyM6urO2pdzl32zippVdvkJXp/eLioZh
         eIyuABuzCynr3FErbnsfXfERhkMg8kaaYWsp0clk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ZhangXiaoxu <zhangxiaoxu5@huawei.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 5.2 140/162] dm space map metadata: fix missing store of apply_bops() return value
Date:   Tue, 27 Aug 2019 09:51:08 +0200
Message-Id: <20190827072743.516656569@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
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
 


