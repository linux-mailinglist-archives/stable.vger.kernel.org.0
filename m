Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4F24699BE
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236902AbhLFPDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:03:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344964AbhLFPCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:02:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49148C061D7F;
        Mon,  6 Dec 2021 06:59:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C09B56131C;
        Mon,  6 Dec 2021 14:59:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4E43C341D2;
        Mon,  6 Dec 2021 14:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802763;
        bh=gO3FsktaD+ahvdu0ydIXlULndKJtijU07K2bT5GYWwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+1UcS2PMT7yd81XbGBo6UOmskn6rxZvUVMlWV6VtvfBuC14JWDIzpWjjlDuOpr8f
         RdK9OawCv+8WXb7vBm6xOgJyugutExsY+BqI87fuRjSzcf+/6IChtn1OsnMcg52f7k
         NFHkKaMQ7kzLd8Tb1WTENY4fvCtWLdFb7Y16QR9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>
Subject: [PATCH 4.4 25/52] xen: sync include/xen/interface/io/ring.h with Xens newest version
Date:   Mon,  6 Dec 2021 15:56:09 +0100
Message-Id: <20211206145548.748748300@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145547.892668902@linuxfoundation.org>
References: <20211206145547.892668902@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 629a5d87e26fe96bcaab44cbb81f5866af6f7008 upstream.

Sync include/xen/interface/io/ring.h with Xen's newest version in
order to get the RING_COPY_RESPONSE() and RING_RESPONSE_PROD_OVERFLOW()
macros.

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/xen/interface/io/ring.h |  271 +++++++++++++++++++---------------------
 1 file changed, 131 insertions(+), 140 deletions(-)

--- a/include/xen/interface/io/ring.h
+++ b/include/xen/interface/io/ring.h
@@ -24,82 +24,79 @@ typedef unsigned int RING_IDX;
  * A ring contains as many entries as will fit, rounded down to the nearest
  * power of two (so we can mask with (size-1) to loop around).
  */
-#define __CONST_RING_SIZE(_s, _sz)				\
-	(__RD32(((_sz) - offsetof(struct _s##_sring, ring)) /	\
-		sizeof(((struct _s##_sring *)0)->ring[0])))
-
+#define __CONST_RING_SIZE(_s, _sz) \
+    (__RD32(((_sz) - offsetof(struct _s##_sring, ring)) / \
+	    sizeof(((struct _s##_sring *)0)->ring[0])))
 /*
  * The same for passing in an actual pointer instead of a name tag.
  */
-#define __RING_SIZE(_s, _sz)						\
-	(__RD32(((_sz) - (long)&(_s)->ring + (long)(_s)) / sizeof((_s)->ring[0])))
+#define __RING_SIZE(_s, _sz) \
+    (__RD32(((_sz) - (long)(_s)->ring + (long)(_s)) / sizeof((_s)->ring[0])))
 
 /*
  * Macros to make the correct C datatypes for a new kind of ring.
  *
  * To make a new ring datatype, you need to have two message structures,
- * let's say struct request, and struct response already defined.
+ * let's say request_t, and response_t already defined.
  *
  * In a header where you want the ring datatype declared, you then do:
  *
- *     DEFINE_RING_TYPES(mytag, struct request, struct response);
+ *     DEFINE_RING_TYPES(mytag, request_t, response_t);
  *
  * These expand out to give you a set of types, as you can see below.
  * The most important of these are:
  *
- *     struct mytag_sring      - The shared ring.
- *     struct mytag_front_ring - The 'front' half of the ring.
- *     struct mytag_back_ring  - The 'back' half of the ring.
+ *     mytag_sring_t      - The shared ring.
+ *     mytag_front_ring_t - The 'front' half of the ring.
+ *     mytag_back_ring_t  - The 'back' half of the ring.
  *
  * To initialize a ring in your code you need to know the location and size
  * of the shared memory area (PAGE_SIZE, for instance). To initialise
  * the front half:
  *
- *     struct mytag_front_ring front_ring;
- *     SHARED_RING_INIT((struct mytag_sring *)shared_page);
- *     FRONT_RING_INIT(&front_ring, (struct mytag_sring *)shared_page,
- *		       PAGE_SIZE);
+ *     mytag_front_ring_t front_ring;
+ *     SHARED_RING_INIT((mytag_sring_t *)shared_page);
+ *     FRONT_RING_INIT(&front_ring, (mytag_sring_t *)shared_page, PAGE_SIZE);
  *
  * Initializing the back follows similarly (note that only the front
  * initializes the shared ring):
  *
- *     struct mytag_back_ring back_ring;
- *     BACK_RING_INIT(&back_ring, (struct mytag_sring *)shared_page,
- *		      PAGE_SIZE);
+ *     mytag_back_ring_t back_ring;
+ *     BACK_RING_INIT(&back_ring, (mytag_sring_t *)shared_page, PAGE_SIZE);
  */
 
-#define DEFINE_RING_TYPES(__name, __req_t, __rsp_t)			\
-									\
-/* Shared ring entry */							\
-union __name##_sring_entry {						\
-    __req_t req;							\
-    __rsp_t rsp;							\
-};									\
-									\
-/* Shared ring page */							\
-struct __name##_sring {							\
-    RING_IDX req_prod, req_event;					\
-    RING_IDX rsp_prod, rsp_event;					\
-    uint8_t  pad[48];							\
-    union __name##_sring_entry ring[1]; /* variable-length */		\
-};									\
-									\
-/* "Front" end's private variables */					\
-struct __name##_front_ring {						\
-    RING_IDX req_prod_pvt;						\
-    RING_IDX rsp_cons;							\
-    unsigned int nr_ents;						\
-    struct __name##_sring *sring;					\
-};									\
-									\
-/* "Back" end's private variables */					\
-struct __name##_back_ring {						\
-    RING_IDX rsp_prod_pvt;						\
-    RING_IDX req_cons;							\
-    unsigned int nr_ents;						\
-    struct __name##_sring *sring;					\
-};
-
+#define DEFINE_RING_TYPES(__name, __req_t, __rsp_t)                     \
+                                                                        \
+/* Shared ring entry */                                                 \
+union __name##_sring_entry {                                            \
+    __req_t req;                                                        \
+    __rsp_t rsp;                                                        \
+};                                                                      \
+                                                                        \
+/* Shared ring page */                                                  \
+struct __name##_sring {                                                 \
+    RING_IDX req_prod, req_event;                                       \
+    RING_IDX rsp_prod, rsp_event;                                       \
+    uint8_t __pad[48];                                                  \
+    union __name##_sring_entry ring[1]; /* variable-length */           \
+};                                                                      \
+                                                                        \
+/* "Front" end's private variables */                                   \
+struct __name##_front_ring {                                            \
+    RING_IDX req_prod_pvt;                                              \
+    RING_IDX rsp_cons;                                                  \
+    unsigned int nr_ents;                                               \
+    struct __name##_sring *sring;                                       \
+};                                                                      \
+                                                                        \
+/* "Back" end's private variables */                                    \
+struct __name##_back_ring {                                             \
+    RING_IDX rsp_prod_pvt;                                              \
+    RING_IDX req_cons;                                                  \
+    unsigned int nr_ents;                                               \
+    struct __name##_sring *sring;                                       \
+};                                                                      \
+                                                                        \
 /*
  * Macros for manipulating rings.
  *
@@ -116,105 +113,99 @@ struct __name##_back_ring {						\
  */
 
 /* Initialising empty rings */
-#define SHARED_RING_INIT(_s) do {					\
-    (_s)->req_prod  = (_s)->rsp_prod  = 0;				\
-    (_s)->req_event = (_s)->rsp_event = 1;				\
-    memset((_s)->pad, 0, sizeof((_s)->pad));				\
+#define SHARED_RING_INIT(_s) do {                                       \
+    (_s)->req_prod  = (_s)->rsp_prod  = 0;                              \
+    (_s)->req_event = (_s)->rsp_event = 1;                              \
+    (void)memset((_s)->__pad, 0, sizeof((_s)->__pad));                  \
 } while(0)
 
-#define FRONT_RING_INIT(_r, _s, __size) do {				\
-    (_r)->req_prod_pvt = 0;						\
-    (_r)->rsp_cons = 0;							\
-    (_r)->nr_ents = __RING_SIZE(_s, __size);				\
-    (_r)->sring = (_s);							\
+#define FRONT_RING_ATTACH(_r, _s, _i, __size) do {                      \
+    (_r)->req_prod_pvt = (_i);                                          \
+    (_r)->rsp_cons = (_i);                                              \
+    (_r)->nr_ents = __RING_SIZE(_s, __size);                            \
+    (_r)->sring = (_s);                                                 \
 } while (0)
 
-#define BACK_RING_INIT(_r, _s, __size) do {				\
-    (_r)->rsp_prod_pvt = 0;						\
-    (_r)->req_cons = 0;							\
-    (_r)->nr_ents = __RING_SIZE(_s, __size);				\
-    (_r)->sring = (_s);							\
-} while (0)
+#define FRONT_RING_INIT(_r, _s, __size) FRONT_RING_ATTACH(_r, _s, 0, __size)
 
-/* Initialize to existing shared indexes -- for recovery */
-#define FRONT_RING_ATTACH(_r, _s, __size) do {				\
-    (_r)->sring = (_s);							\
-    (_r)->req_prod_pvt = (_s)->req_prod;				\
-    (_r)->rsp_cons = (_s)->rsp_prod;					\
-    (_r)->nr_ents = __RING_SIZE(_s, __size);				\
+#define BACK_RING_ATTACH(_r, _s, _i, __size) do {                       \
+    (_r)->rsp_prod_pvt = (_i);                                          \
+    (_r)->req_cons = (_i);                                              \
+    (_r)->nr_ents = __RING_SIZE(_s, __size);                            \
+    (_r)->sring = (_s);                                                 \
 } while (0)
 
-#define BACK_RING_ATTACH(_r, _s, __size) do {				\
-    (_r)->sring = (_s);							\
-    (_r)->rsp_prod_pvt = (_s)->rsp_prod;				\
-    (_r)->req_cons = (_s)->req_prod;					\
-    (_r)->nr_ents = __RING_SIZE(_s, __size);				\
-} while (0)
+#define BACK_RING_INIT(_r, _s, __size) BACK_RING_ATTACH(_r, _s, 0, __size)
 
 /* How big is this ring? */
-#define RING_SIZE(_r)							\
+#define RING_SIZE(_r)                                                   \
     ((_r)->nr_ents)
 
 /* Number of free requests (for use on front side only). */
-#define RING_FREE_REQUESTS(_r)						\
+#define RING_FREE_REQUESTS(_r)                                          \
     (RING_SIZE(_r) - ((_r)->req_prod_pvt - (_r)->rsp_cons))
 
 /* Test if there is an empty slot available on the front ring.
  * (This is only meaningful from the front. )
  */
-#define RING_FULL(_r)							\
+#define RING_FULL(_r)                                                   \
     (RING_FREE_REQUESTS(_r) == 0)
 
 /* Test if there are outstanding messages to be processed on a ring. */
-#define RING_HAS_UNCONSUMED_RESPONSES(_r)				\
+#define RING_HAS_UNCONSUMED_RESPONSES(_r)                               \
     ((_r)->sring->rsp_prod - (_r)->rsp_cons)
 
-#define RING_HAS_UNCONSUMED_REQUESTS(_r)				\
-    ({									\
-	unsigned int req = (_r)->sring->req_prod - (_r)->req_cons;	\
-	unsigned int rsp = RING_SIZE(_r) -				\
-			   ((_r)->req_cons - (_r)->rsp_prod_pvt);	\
-	req < rsp ? req : rsp;						\
-    })
+#define RING_HAS_UNCONSUMED_REQUESTS(_r) ({                             \
+    unsigned int req = (_r)->sring->req_prod - (_r)->req_cons;          \
+    unsigned int rsp = RING_SIZE(_r) -                                  \
+        ((_r)->req_cons - (_r)->rsp_prod_pvt);                          \
+    req < rsp ? req : rsp;                                              \
+})
 
 /* Direct access to individual ring elements, by index. */
-#define RING_GET_REQUEST(_r, _idx)					\
+#define RING_GET_REQUEST(_r, _idx)                                      \
     (&((_r)->sring->ring[((_idx) & (RING_SIZE(_r) - 1))].req))
 
+#define RING_GET_RESPONSE(_r, _idx)                                     \
+    (&((_r)->sring->ring[((_idx) & (RING_SIZE(_r) - 1))].rsp))
+
 /*
- * Get a local copy of a request.
+ * Get a local copy of a request/response.
  *
- * Use this in preference to RING_GET_REQUEST() so all processing is
+ * Use this in preference to RING_GET_{REQUEST,RESPONSE}() so all processing is
  * done on a local copy that cannot be modified by the other end.
  *
  * Note that https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145 may cause this
- * to be ineffective where _req is a struct which consists of only bitfields.
+ * to be ineffective where dest is a struct which consists of only bitfields.
  */
-#define RING_COPY_REQUEST(_r, _idx, _req) do {				\
-	/* Use volatile to force the copy into _req. */			\
-	*(_req) = *(volatile typeof(_req))RING_GET_REQUEST(_r, _idx);	\
+#define RING_COPY_(type, r, idx, dest) do {				\
+	/* Use volatile to force the copy into dest. */			\
+	*(dest) = *(volatile typeof(dest))RING_GET_##type(r, idx);	\
 } while (0)
 
-#define RING_GET_RESPONSE(_r, _idx)					\
-    (&((_r)->sring->ring[((_idx) & (RING_SIZE(_r) - 1))].rsp))
+#define RING_COPY_REQUEST(r, idx, req)  RING_COPY_(REQUEST, r, idx, req)
+#define RING_COPY_RESPONSE(r, idx, rsp) RING_COPY_(RESPONSE, r, idx, rsp)
 
 /* Loop termination condition: Would the specified index overflow the ring? */
-#define RING_REQUEST_CONS_OVERFLOW(_r, _cons)				\
+#define RING_REQUEST_CONS_OVERFLOW(_r, _cons)                           \
     (((_cons) - (_r)->rsp_prod_pvt) >= RING_SIZE(_r))
 
 /* Ill-behaved frontend determination: Can there be this many requests? */
-#define RING_REQUEST_PROD_OVERFLOW(_r, _prod)               \
+#define RING_REQUEST_PROD_OVERFLOW(_r, _prod)                           \
     (((_prod) - (_r)->rsp_prod_pvt) > RING_SIZE(_r))
 
-
-#define RING_PUSH_REQUESTS(_r) do {					\
-    wmb(); /* back sees requests /before/ updated producer index */	\
-    (_r)->sring->req_prod = (_r)->req_prod_pvt;				\
+/* Ill-behaved backend determination: Can there be this many responses? */
+#define RING_RESPONSE_PROD_OVERFLOW(_r, _prod)                          \
+    (((_prod) - (_r)->rsp_cons) > RING_SIZE(_r))
+
+#define RING_PUSH_REQUESTS(_r) do {                                    \
+    wmb(); /* back sees requests /before/ updated producer index */    \
+    (_r)->sring->req_prod = (_r)->req_prod_pvt;                        \
 } while (0)
 
-#define RING_PUSH_RESPONSES(_r) do {					\
-    wmb(); /* front sees responses /before/ updated producer index */	\
-    (_r)->sring->rsp_prod = (_r)->rsp_prod_pvt;				\
+#define RING_PUSH_RESPONSES(_r) do {                                   \
+    wmb(); /* front sees resps /before/ updated producer index */      \
+    (_r)->sring->rsp_prod = (_r)->rsp_prod_pvt;                        \
 } while (0)
 
 /*
@@ -247,40 +238,40 @@ struct __name##_back_ring {						\
  *  field appropriately.
  */
 
-#define RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(_r, _notify) do {		\
-    RING_IDX __old = (_r)->sring->req_prod;				\
-    RING_IDX __new = (_r)->req_prod_pvt;				\
-    wmb(); /* back sees requests /before/ updated producer index */	\
-    (_r)->sring->req_prod = __new;					\
-    mb(); /* back sees new requests /before/ we check req_event */	\
-    (_notify) = ((RING_IDX)(__new - (_r)->sring->req_event) <		\
-		 (RING_IDX)(__new - __old));				\
-} while (0)
-
-#define RING_PUSH_RESPONSES_AND_CHECK_NOTIFY(_r, _notify) do {		\
-    RING_IDX __old = (_r)->sring->rsp_prod;				\
-    RING_IDX __new = (_r)->rsp_prod_pvt;				\
-    wmb(); /* front sees responses /before/ updated producer index */	\
-    (_r)->sring->rsp_prod = __new;					\
-    mb(); /* front sees new responses /before/ we check rsp_event */	\
-    (_notify) = ((RING_IDX)(__new - (_r)->sring->rsp_event) <		\
-		 (RING_IDX)(__new - __old));				\
-} while (0)
-
-#define RING_FINAL_CHECK_FOR_REQUESTS(_r, _work_to_do) do {		\
-    (_work_to_do) = RING_HAS_UNCONSUMED_REQUESTS(_r);			\
-    if (_work_to_do) break;						\
-    (_r)->sring->req_event = (_r)->req_cons + 1;			\
-    mb();								\
-    (_work_to_do) = RING_HAS_UNCONSUMED_REQUESTS(_r);			\
-} while (0)
-
-#define RING_FINAL_CHECK_FOR_RESPONSES(_r, _work_to_do) do {		\
-    (_work_to_do) = RING_HAS_UNCONSUMED_RESPONSES(_r);			\
-    if (_work_to_do) break;						\
-    (_r)->sring->rsp_event = (_r)->rsp_cons + 1;			\
-    mb();								\
-    (_work_to_do) = RING_HAS_UNCONSUMED_RESPONSES(_r);			\
+#define RING_PUSH_REQUESTS_AND_CHECK_NOTIFY(_r, _notify) do {          \
+    RING_IDX __old = (_r)->sring->req_prod;                            \
+    RING_IDX __new = (_r)->req_prod_pvt;                               \
+    wmb(); /* back sees requests /before/ updated producer index */    \
+    (_r)->sring->req_prod = __new;                                     \
+    mb(); /* back sees new requests /before/ we check req_event */     \
+    (_notify) = ((RING_IDX)(__new - (_r)->sring->req_event) <          \
+                 (RING_IDX)(__new - __old));                           \
+} while (0)
+
+#define RING_PUSH_RESPONSES_AND_CHECK_NOTIFY(_r, _notify) do {         \
+    RING_IDX __old = (_r)->sring->rsp_prod;                            \
+    RING_IDX __new = (_r)->rsp_prod_pvt;                               \
+    wmb(); /* front sees resps /before/ updated producer index */      \
+    (_r)->sring->rsp_prod = __new;                                     \
+    mb(); /* front sees new resps /before/ we check rsp_event */       \
+    (_notify) = ((RING_IDX)(__new - (_r)->sring->rsp_event) <          \
+                 (RING_IDX)(__new - __old));                           \
+} while (0)
+
+#define RING_FINAL_CHECK_FOR_REQUESTS(_r, _work_to_do) do {            \
+    (_work_to_do) = RING_HAS_UNCONSUMED_REQUESTS(_r);                  \
+    if (_work_to_do) break;                                            \
+    (_r)->sring->req_event = (_r)->req_cons + 1;                       \
+    mb();                                                              \
+    (_work_to_do) = RING_HAS_UNCONSUMED_REQUESTS(_r);                  \
+} while (0)
+
+#define RING_FINAL_CHECK_FOR_RESPONSES(_r, _work_to_do) do {           \
+    (_work_to_do) = RING_HAS_UNCONSUMED_RESPONSES(_r);                 \
+    if (_work_to_do) break;                                            \
+    (_r)->sring->rsp_event = (_r)->rsp_cons + 1;                       \
+    mb();                                                              \
+    (_work_to_do) = RING_HAS_UNCONSUMED_RESPONSES(_r);                 \
 } while (0)
 
 #endif /* __XEN_PUBLIC_IO_RING_H__ */


