Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFC2714B202
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 10:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726108AbgA1Jut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 04:50:49 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:40051 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726107AbgA1Jut (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 04:50:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580205048;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D4opH4jOF22ekUBHPbXZH3iXm1GbOIfJkhO9T3Sufwo=;
        b=IO2B8d7k5O3fwSvJ9dl44tgII9jnxaQpGLYQxl+82G0ORTZVS6XycTwbVoVlB7rnQYIWbf
        atOmeGGk8oYFj4YLyvB6PdNmxTt+z0KCLFH6C3/63QQYWJ1vdOmjajdw/lQ6JBhiuZr2F2
        GsQEZ1RWuoVNzm1XUZwWbZ6MfEI+SRY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-163-cj-Jee4uMemHfP1HduDikQ-1; Tue, 28 Jan 2020 04:50:39 -0500
X-MC-Unique: cj-Jee4uMemHfP1HduDikQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DEDBD800D4C;
        Tue, 28 Jan 2020 09:50:37 +0000 (UTC)
Received: from t480s.redhat.com (ovpn-116-207.ams2.redhat.com [10.36.116.207])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B2FB860C05;
        Tue, 28 Jan 2020 09:50:35 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
        Baoquan He <bhe@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Oscar Salvador <osalvador@suse.de>,
        Wei Yang <richard.weiyang@gmail.com>,
        David Hildenbrand <david@redhat.com>
Subject: [PATCH for 4.19-stable v3 04/24] drivers/base/memory.c: remove an unnecessary check on NR_MEM_SECTIONS
Date:   Tue, 28 Jan 2020 10:50:01 +0100
Message-Id: <20200128095021.8076-5-david@redhat.com>
In-Reply-To: <20200128095021.8076-1-david@redhat.com>
References: <20200128095021.8076-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yang <richard.weiyang@gmail.com>

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

