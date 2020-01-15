Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D5D913C7D4
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 16:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgAOPeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 10:34:01 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49175 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726506AbgAOPeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 10:34:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579102439;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=an0vq7yOiwLu/DKffCDtFH2s3tpP8nyYXflOxlbg+fQ=;
        b=hFP0SXTI/51huln0vno6RYY3JYcuXYETwoIoSDcO/cONWZ+XGz90YBsh68kU27kGLiEZgc
        xHQ9OpHzvPtlPLgq7i5B7ZX6HvikMGy0SewluUAsEDiy61mumPUzoNzClLaCohQE5MjaCw
        YkdufRymaMdm+oI7Y/Ecd8NX8Y/9Y6Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-10-RGM9XVmxOz-carv1aki1ow-1; Wed, 15 Jan 2020 10:33:55 -0500
X-MC-Unique: RGM9XVmxOz-carv1aki1ow-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 58509109A66A;
        Wed, 15 Jan 2020 15:33:54 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.36.118.7])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2DD2F89D2B;
        Wed, 15 Jan 2020 15:33:52 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, Oscar Salvador <osalvador@suse.de>,
        Michal Hocko <mhocko@suse.com>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Laurent Vivier <lvivier@redhat.com>,
        Baoquan He <bhe@redhat.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH for 4.19-stable 04/25] drivers/base/memory.c: remove an unnecessary check on NR_MEM_SECTIONS
Date:   Wed, 15 Jan 2020 16:33:18 +0100
Message-Id: <20200115153339.36409-5-david@redhat.com>
In-Reply-To: <20200115153339.36409-1-david@redhat.com>
References: <20200115153339.36409-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 3b6fd6ffb27c2efa003c6d4d15ca72c054b71d7c upstream.

In cb5e39b8038b ("drivers: base: refactor add_memory_section() to
add_memory_block()"), add_memory_block() is introduced, which is only
invoked in memory_dev_init().

When combining these two loops in memory_dev_init() and
add_memory_block(), they looks like this:

    for (i =3D 0; i < NR_MEM_SECTIONS; i +=3D sections_per_block)
        for (j =3D i;
	    (j < i + sections_per_block) && j < NR_MEM_SECTIONS;
	    j++)

Since it is sure the (i < NR_MEM_SECTIONS) and j sits in its own memory
block, the check of (j < NR_MEM_SECTIONS) is not necessary.

This patch just removes this check.

Link: http://lkml.kernel.org/r/20181123222811.18216-1-richard.weiyang@gma=
il.com
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Seth Jennings <sjenning@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/base/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index ac1574a69610..5fca7225f3fe 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -691,7 +691,7 @@ static int add_memory_block(int base_section_nr)
 	int i, ret, section_count =3D 0, section_nr;
=20
 	for (i =3D base_section_nr;
-	     (i < base_section_nr + sections_per_block) && i < NR_MEM_SECTIONS;
+	     i < base_section_nr + sections_per_block;
 	     i++) {
 		if (!present_section_nr(i))
 			continue;
--=20
2.24.1

