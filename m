Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 131511D8641
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730362AbgERRsY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:48:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:49136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730353AbgERRsV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:48:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9E3020657;
        Mon, 18 May 2020 17:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824100;
        bh=ASD+fFzp4NJHBwKGUBzfOTPXS0YJQ2vb0CTvZsbplXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWMredkF1Ey4uyZWtGAQv0c3+9AK6qwDKED88XZlk5DXn9kX9/wILQn2sdfk6wByK
         7Eq8sNlLlGmJQ9cBnGwKNK96Hi/xY+E3k/a6psWWGsS95wPsEVx3oNZg5z8Nm4eANI
         tsbmWpXtBA80zsKUPqrrS90ahUU11cbv0CYZx+GY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.14 070/114] pnp: Use list_for_each_entry() instead of open coding
Date:   Mon, 18 May 2020 19:36:42 +0200
Message-Id: <20200518173515.690166282@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173503.033975649@linuxfoundation.org>
References: <20200518173503.033975649@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 01b2bafe57b19d9119413f138765ef57990921ce upstream.

Aside from good practice, this avoids a warning from gcc 10:

./include/linux/kernel.h:997:3: warning: array subscript -31 is outside array bounds of ‘struct list_head[1]’ [-Warray-bounds]
  997 |  ((type *)(__mptr - offsetof(type, member))); })
      |  ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./include/linux/list.h:493:2: note: in expansion of macro ‘container_of’
  493 |  container_of(ptr, type, member)
      |  ^~~~~~~~~~~~
./include/linux/pnp.h:275:30: note: in expansion of macro ‘list_entry’
  275 | #define global_to_pnp_dev(n) list_entry(n, struct pnp_dev, global_list)
      |                              ^~~~~~~~~~
./include/linux/pnp.h:281:11: note: in expansion of macro ‘global_to_pnp_dev’
  281 |  (dev) != global_to_pnp_dev(&pnp_global); \
      |           ^~~~~~~~~~~~~~~~~
arch/x86/kernel/rtc.c:189:2: note: in expansion of macro ‘pnp_for_each_dev’
  189 |  pnp_for_each_dev(dev) {

Because the common code doesn't cast the starting list_head to the
containing struct.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
[ rjw: Whitespace adjustments ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/pnp.h |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

--- a/include/linux/pnp.h
+++ b/include/linux/pnp.h
@@ -220,10 +220,8 @@ struct pnp_card {
 #define global_to_pnp_card(n) list_entry(n, struct pnp_card, global_list)
 #define protocol_to_pnp_card(n) list_entry(n, struct pnp_card, protocol_list)
 #define to_pnp_card(n) container_of(n, struct pnp_card, dev)
-#define pnp_for_each_card(card) \
-	for((card) = global_to_pnp_card(pnp_cards.next); \
-	(card) != global_to_pnp_card(&pnp_cards); \
-	(card) = global_to_pnp_card((card)->global_list.next))
+#define pnp_for_each_card(card)	\
+	list_for_each_entry(card, &pnp_cards, global_list)
 
 struct pnp_card_link {
 	struct pnp_card *card;
@@ -276,14 +274,9 @@ struct pnp_dev {
 #define card_to_pnp_dev(n) list_entry(n, struct pnp_dev, card_list)
 #define protocol_to_pnp_dev(n) list_entry(n, struct pnp_dev, protocol_list)
 #define	to_pnp_dev(n) container_of(n, struct pnp_dev, dev)
-#define pnp_for_each_dev(dev) \
-	for((dev) = global_to_pnp_dev(pnp_global.next); \
-	(dev) != global_to_pnp_dev(&pnp_global); \
-	(dev) = global_to_pnp_dev((dev)->global_list.next))
-#define card_for_each_dev(card,dev) \
-	for((dev) = card_to_pnp_dev((card)->devices.next); \
-	(dev) != card_to_pnp_dev(&(card)->devices); \
-	(dev) = card_to_pnp_dev((dev)->card_list.next))
+#define pnp_for_each_dev(dev) list_for_each_entry(dev, &pnp_global, global_list)
+#define card_for_each_dev(card, dev)	\
+	list_for_each_entry(dev, &(card)->devices, card_list)
 #define pnp_dev_name(dev) (dev)->name
 
 static inline void *pnp_get_drvdata(struct pnp_dev *pdev)
@@ -437,14 +430,10 @@ struct pnp_protocol {
 };
 
 #define to_pnp_protocol(n) list_entry(n, struct pnp_protocol, protocol_list)
-#define protocol_for_each_card(protocol,card) \
-	for((card) = protocol_to_pnp_card((protocol)->cards.next); \
-	(card) != protocol_to_pnp_card(&(protocol)->cards); \
-	(card) = protocol_to_pnp_card((card)->protocol_list.next))
-#define protocol_for_each_dev(protocol,dev) \
-	for((dev) = protocol_to_pnp_dev((protocol)->devices.next); \
-	(dev) != protocol_to_pnp_dev(&(protocol)->devices); \
-	(dev) = protocol_to_pnp_dev((dev)->protocol_list.next))
+#define protocol_for_each_card(protocol, card)	\
+	list_for_each_entry(card, &(protocol)->cards, protocol_list)
+#define protocol_for_each_dev(protocol, dev)	\
+	list_for_each_entry(dev, &(protocol)->devices, protocol_list)
 
 extern struct bus_type pnp_bus_type;
 


