Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFE41025A1
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 14:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726555AbfKSNle (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 08:41:34 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44528 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfKSNle (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 08:41:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574170893;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tmJK/bMOM/h7njGCd0+7n8mLcwuxh5LcRErS125lK/E=;
        b=XZuhOEsQnMnyD69KS8pzoA3A9KaG8WgovazPiVrTxQ1lbG4zN8V5xGBSPkBL+Qz+BsXsa6
        UC/EFQGlOOizfobzt9/LXoh0nJkfGed4BNo9glyupKG1UWW6Dt9H6bq5ExMQw1AJobzMis
        mBw2kCc7Fbq3giJf1COLrJBvRqMOrs4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-15-jOar8NNnOS2KQ9d44Dempw-1; Tue, 19 Nov 2019 08:41:29 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D76B6102C85E;
        Tue, 19 Nov 2019 13:41:27 +0000 (UTC)
Received: from t460s.redhat.com (ovpn-117-126.ams2.redhat.com [10.36.117.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DB53469193;
        Tue, 19 Nov 2019 13:41:24 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Williams <dan.j.williams@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: [PATCH for 4.14-stable 2/2] mm/memory_hotplug: fix updating the node span
Date:   Tue, 19 Nov 2019 14:41:07 +0100
Message-Id: <20191119134108.9420-2-david@redhat.com>
In-Reply-To: <20191119134108.9420-1-david@redhat.com>
References: <15721838171019@kroah.com>
 <20191119134108.9420-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: jOar8NNnOS2KQ9d44Dempw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 656d571193262a11c2daa4012e53e4d645bbce56 upstream.

We recently started updating the node span based on the zone span to
avoid touching uninitialized memmaps.

Currently, we will always detect the node span to start at 0, meaning a
node can easily span too many pages.  pgdat_is_empty() will still work
correctly if all zones span no pages.  We should skip over all zones
without spanned pages and properly handle the first detected zone that
spans pages.

Unfortunately, in contrast to the zone span (/proc/zoneinfo), the node
span cannot easily be inspected and tested.  The node span gives no real
guarantees when an architecture supports memory hotplug, meaning it can
easily contain holes or span pages of different nodes.

The node span is not really used after init on architectures that
support memory hotplug.

E.g., we use it in mm/memory_hotplug.c:try_offline_node() and in
mm/kmemleak.c:kmemleak_scan().  These users seem to be fine.

Link: http://lkml.kernel.org/r/20191027222714.5313-1-david@redhat.com
Fixes: 00d6c019b5bc ("mm/memory_hotplug: don't access uninitialized memmaps=
 in shrink_pgdat_span()")
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/memory_hotplug.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 9cd25b19e111..d4affa9982ca 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -470,6 +470,14 @@ static void update_pgdat_span(struct pglist_data *pgda=
t)
 =09=09=09=09=09     zone->spanned_pages;
=20
 =09=09/* No need to lock the zones, they can't change. */
+=09=09if (!zone->spanned_pages)
+=09=09=09continue;
+=09=09if (!node_end_pfn) {
+=09=09=09node_start_pfn =3D zone->zone_start_pfn;
+=09=09=09node_end_pfn =3D zone_end_pfn;
+=09=09=09continue;
+=09=09}
+
 =09=09if (zone_end_pfn > node_end_pfn)
 =09=09=09node_end_pfn =3D zone_end_pfn;
 =09=09if (zone->zone_start_pfn < node_start_pfn)
--=20
2.21.0

