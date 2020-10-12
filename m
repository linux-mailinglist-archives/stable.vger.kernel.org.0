Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC8928B740
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:42:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730667AbgJLNlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:41:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:45618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389108AbgJLNlL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:41:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2F4BD2076E;
        Mon, 12 Oct 2020 13:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510070;
        bh=Ccz4JWh+v4134ZyEbJ2S3IXk2/venNaodAGSpyjqWwU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fKtczoa5ImfixHfEkB5l3BqTblp58vAOaO+AY9rV6TIsSyWF1aTHNj3Q3Tqm56sAF
         Z/WUrkETnHkDSUVCnPBhEk1nbLdIwCHFxFT+zeuWr78KkZ8ASB79RaulN9QtugS0GK
         omFD53hhvb3orI6R+DcAOnSPPacUUMLe+B0AI0BQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>,
        Josef Bacik <josef@toxicpanda.com>, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>,
        Anand Jain <anand.jain@oracle.com>
Subject: [PATCH 5.4 28/85] btrfs: volumes: Use more straightforward way to calculate map length
Date:   Mon, 12 Oct 2020 15:26:51 +0200
Message-Id: <20201012132634.207705689@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qu Wenruo <wqu@suse.com>

commit 2d974619a77f106f3d1341686dea95c0eaad601f upstream.

The old code goes:

 	offset = logical - em->start;
	length = min_t(u64, em->len - offset, length);

Where @length calculation is dependent on offset, it can take reader
several more seconds to find it's just the same code as:

 	offset = logical - em->start;
	length = min_t(u64, em->start + em->len - logical, length);

Use above code to make the length calculate independent from other
variable, thus slightly increase the readability.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Reviewed-by: David Sterba <dsterba@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/volumes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5714,7 +5714,7 @@ static int __btrfs_map_block_for_discard
 	}
 
 	offset = logical - em->start;
-	length = min_t(u64, em->len - offset, length);
+	length = min_t(u64, em->start + em->len - logical, length);
 
 	stripe_len = map->stripe_len;
 	/*


