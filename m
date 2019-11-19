Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1EB1025DF
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 15:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726185AbfKSOGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 09:06:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27671 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725904AbfKSOGy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 09:06:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574172413;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BIg/JSZqyOmFuriHvBBCX7y8B8J5X/hvl12qsClRVS0=;
        b=FTOBJRIZH6RBSSMs6Rplt8w6AIunFEBvCI/qdpog6eMe7Tos4Vla/orxtTmrNsmbY5iLAY
        BOg29lUO+G6m2Xw2gM4cU/kiNv7yFP0P6WZuS3WcCiyMUkB8hUZx41cxZCCYOHIxoCHVu/
        ETWeyEa/EHcj40+vou5oJa8mU0bK4SA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-ULWi9S7FNGu3Kd-oLT8GnA-1; Tue, 19 Nov 2019 09:06:50 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0B1A1852E22;
        Tue, 19 Nov 2019 14:06:48 +0000 (UTC)
Received: from t460s.redhat.com (ovpn-117-126.ams2.redhat.com [10.36.117.126])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05491627DE;
        Tue, 19 Nov 2019 14:06:46 +0000 (UTC)
From:   David Hildenbrand <david@redhat.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, David Hildenbrand <david@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Oscar Salvador <osalvador@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Dan Williams <dan.j.williams@intel.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: [PATCH for 4.19-stable 2/2] mm/memory_hotplug: fix updating the node span
Date:   Tue, 19 Nov 2019 15:06:32 +0100
Message-Id: <20191119140632.9895-2-david@redhat.com>
In-Reply-To: <20191119140632.9895-1-david@redhat.com>
References: <1572183819118174@kroah.com>
 <20191119140632.9895-1-david@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: ULWi9S7FNGu3Kd-oLT8GnA-1
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
index 619b81383e1f..7965112eb063 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -448,6 +448,14 @@ static void update_pgdat_span(struct pglist_data *pgda=
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

