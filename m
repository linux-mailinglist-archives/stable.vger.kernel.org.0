Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26B6C1443EC
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 19:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgAUSCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 13:02:51 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:29400 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729429AbgAUSCu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 13:02:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579629769;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=enpyKzeC1X3YABCaiQ7Mlo8dBePEp5sYNrJlGn2EajY=;
        b=KXcoDBNNmaTwFtUhfML77/PCEzidK7aEu8uaQsrt2+EzDo69hAGTOiXGIPD5anGBRTfqWa
        9PjEDU04ODlr8DSU9putk2encoVBeKz4qG4oWv+Kznb04k+/9nqVdFwKgaN56FWDjEq/nU
        ehEZxQASHqprQxxitip04X6woCBOBWQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-WVH-CfYSPYK9TPOx_Y4erw-1; Tue, 21 Jan 2020 13:02:37 -0500
X-MC-Unique: WVH-CfYSPYK9TPOx_Y4erw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E4721005513;
        Tue, 21 Jan 2020 18:02:35 +0000 (UTC)
Received: from t480s.redhat.com (unknown [10.36.118.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7A01C5C1C3;
        Tue, 21 Jan 2020 18:02:32 +0000 (UTC)
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
Subject: [PATCH for 4.19-stable v2 09/24] mm/memory_hotplug: make unregister_memory_section() never fail
Date:   Tue, 21 Jan 2020 19:01:35 +0100
Message-Id: <20200121180150.37454-10-david@redhat.com>
In-Reply-To: <20200121180150.37454-1-david@redhat.com>
References: <20200121180150.37454-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit cb7b3a3685b20d3b5900ff24b2cb96d002960189 upstream.

Failing while removing memory is mostly ignored and cannot really be
handled.  Let's treat errors in unregister_memory_section() in a nice way=
,
warning, but continuing.

Link: http://lkml.kernel.org/r/20190409100148.24703-3-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Andrew Banman <andrew.banman@hpe.com>
Cc: Mike Travis <mike.travis@hpe.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Arun KS <arunks@codeaurora.org>
Cc: Mathieu Malaterre <malat@debian.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Oscar Salvador <osalvador@suse.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rich Felker <dalias@libc.org>
Cc: Rob Herring <robh@kernel.org>
Cc: Stefan Agner <stefan@agner.ch>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 drivers/base/memory.c  | 16 +++++-----------
 include/linux/memory.h |  2 +-
 mm/memory_hotplug.c    |  4 +---
 3 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 119b076eb5e2..5b9950d982dc 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -743,15 +743,18 @@ unregister_memory(struct memory_block *memory)
 {
 	BUG_ON(memory->dev.bus !=3D &memory_subsys);
=20
-	/* drop the ref. we got in remove_memory_section() */
+	/* drop the ref. we got via find_memory_block() */
 	put_device(&memory->dev);
 	device_unregister(&memory->dev);
 }
=20
-static int remove_memory_section(struct mem_section *section)
+void unregister_memory_section(struct mem_section *section)
 {
 	struct memory_block *mem;
=20
+	if (WARN_ON_ONCE(!present_section(section)))
+		return;
+
 	mutex_lock(&mem_sysfs_mutex);
=20
 	/*
@@ -772,15 +775,6 @@ static int remove_memory_section(struct mem_section =
*section)
=20
 out_unlock:
 	mutex_unlock(&mem_sysfs_mutex);
-	return 0;
-}
-
-int unregister_memory_section(struct mem_section *section)
-{
-	if (!present_section(section))
-		return -EINVAL;
-
-	return remove_memory_section(section);
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
=20
diff --git a/include/linux/memory.h b/include/linux/memory.h
index a6ddefc60517..e1dc1bb2b787 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -113,7 +113,7 @@ extern int register_memory_isolate_notifier(struct no=
tifier_block *nb);
 extern void unregister_memory_isolate_notifier(struct notifier_block *nb=
);
 int hotplug_memory_register(int nid, struct mem_section *section);
 #ifdef CONFIG_MEMORY_HOTREMOVE
-extern int unregister_memory_section(struct mem_section *);
+extern void unregister_memory_section(struct mem_section *);
 #endif
 extern int memory_dev_init(void);
 extern int memory_notify(unsigned long val, void *v);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 418d589552b3..42c5bc371ffe 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -488,9 +488,7 @@ static int __remove_section(struct zone *zone, struct=
 mem_section *ms,
 	if (!valid_section(ms))
 		return ret;
=20
-	ret =3D unregister_memory_section(ms);
-	if (ret)
-		return ret;
+	unregister_memory_section(ms);
=20
 	scn_nr =3D __section_nr(ms);
 	start_pfn =3D section_nr_to_pfn((unsigned long)scn_nr);
--=20
2.24.1

