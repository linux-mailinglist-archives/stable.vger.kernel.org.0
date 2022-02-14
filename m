Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDA24B4EEC
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 12:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352901AbiBNLm4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 06:42:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353228AbiBNLlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 06:41:44 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576676541F
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 03:32:56 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id k1so26291801wrd.8
        for <stable@vger.kernel.org>; Mon, 14 Feb 2022 03:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xn2piU/pLQrP1POHhOxBkKGcnHmZbmaM/8YevQsPDU8=;
        b=YrO//7eL64FL84QKwjz5iZaMXJB2mPbNASc8b+kcpDeAPqBDn2cizOqtiS+5rgXOtk
         hWjZaRtFVTnrnHLj/o77EyiCpfRL+RV9uTrzRcKp/PWEH6zlhbdgQIRbfdbFUDureR1f
         CMgee8FAnYBp8tFmICykWMEGdGZXhxg2sStdxrxJRRFhq6bu8QDORXGjCbhYn7gYSlXG
         SZKjK0kPmLfO98SdDLgy2RdCyTaPjVEPeHMbjJCputgNH3VvO3rjmO22ebaf2EykjTeT
         LwHsHvVPkQ7b1nHQQBfZIyQdvzy4KY+lwVykqTFtOT/9DkM4rnLJAhBdu2YWiZSfSZD+
         f/mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xn2piU/pLQrP1POHhOxBkKGcnHmZbmaM/8YevQsPDU8=;
        b=x7z1+tYviVTHbbxyAFlYCckzVW+3yOlpJhJ9u7IrHBZmtfFz0GfED7ltcOK+s/tebW
         hFsDiCVrHh0xp+3seaSSNcd24gnoOyqxYp8mSTD0+dBJy1nV0Vt/PtkwaUiUBOgPjClX
         5+I1uyj1HeDxFIm8THQpUhek3Lm5h1KgbBzLQQFIUSl6dbQlo6yiKmHibAFbFKpc/Mku
         4L8mId6eQKF+P+y3wSHFD6Aq2JfqT7nXydkqQwK2a7Iru3/ABkj+TwEx/HQgGH05l+nC
         GTxVj7GDQyZtim556E7nbAIJKKvtZ+FA3yKmj/oTGvHqtJhA6o2vKd7Ce+3SW3DtDyXN
         JC1A==
X-Gm-Message-State: AOAM532lcj76UbgjGNwBmjdk09p23DfhNvJnufC9TAA75p0yqS0opDrd
        ivS7M9YjPzy/v0Q5IgXKpbrsY8gmGaCjnA==
X-Google-Smtp-Source: ABdhPJw+uDTh+y34ltOps63h06wRYb8zEQI1KUtX2bTICXm58ed2ZhLhyr+ZOLmGojLUb7/cLD50dQ==
X-Received: by 2002:a5d:6e91:: with SMTP id k17mr8476502wrz.170.1644838373746;
        Mon, 14 Feb 2022 03:32:53 -0800 (PST)
Received: from localhost ([2a02:168:96c5:1:55ed:514f:6ad7:5bcc])
        by smtp.gmail.com with ESMTPSA id y4sm5680563wrd.54.2022.02.14.03.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Feb 2022 03:32:53 -0800 (PST)
From:   Jann Horn <jannh@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Jann Horn <jannh@google.com>,
        stable@kernel.org
Subject: [PATCH stable 4.9,4.14,4.19] net: usb: ax88179_178a: Fix out-of-bounds accesses in RX fixup
Date:   Mon, 14 Feb 2022 12:32:42 +0100
Message-Id: <20220214113242.686953-1-jannh@google.com>
X-Mailer: git-send-email 2.35.1.265.g69c8d7142f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 57bc3d3ae8c14df3ceb4e17d26ddf9eeab304581 upstream.

ax88179_rx_fixup() contains several out-of-bounds accesses that can be
triggered by a malicious (or defective) USB device, in particular:

 - The metadata array (hdr_off..hdr_off+2*pkt_cnt) can be out of bounds,
   causing OOB reads and (on big-endian systems) OOB endianness flips.
 - A packet can overlap the metadata array, causing a later OOB
   endianness flip to corrupt data used by a cloned SKB that has already
   been handed off into the network stack.
 - A packet SKB can be constructed whose tail is far beyond its end,
   causing out-of-bounds heap data to be considered part of the SKB's
   data.

I have tested that this can be used by a malicious USB device to send a
bogus ICMPv6 Echo Request and receive an ICMPv6 Echo Reply in response
that contains random kernel heap data.
It's probably also possible to get OOB writes from this on a
little-endian system somehow - maybe by triggering skb_cow() via IP
options processing -, but I haven't tested that.

Fixes: e2ca90c276e1 ("ax88179_178a: ASIX AX88179_178A USB 3.0/2.0 to gigabi=
t ethernet adapter driver")
Cc: stable@kernel.org
Signed-off-by: Jann Horn <jannh@google.com>
---
 drivers/net/usb/ax88179_178a.c | 68 +++++++++++++++++++---------------
 1 file changed, 39 insertions(+), 29 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index b2434b479846..684eec0aa0d6 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -1373,59 +1373,69 @@ static int ax88179_rx_fixup(struct usbnet *dev, str=
uct sk_buff *skb)
 	u16 hdr_off;
 	u32 *pkt_hdr;
=20
-	/* This check is no longer done by usbnet */
-	if (skb->len < dev->net->hard_header_len)
+	/* At the end of the SKB, there's a header telling us how many packets
+	 * are bundled into this buffer and where we can find an array of
+	 * per-packet metadata (which contains elements encoded into u16).
+	 */
+	if (skb->len < 4)
 		return 0;
-
 	skb_trim(skb, skb->len - 4);
 	memcpy(&rx_hdr, skb_tail_pointer(skb), 4);
 	le32_to_cpus(&rx_hdr);
-
 	pkt_cnt =3D (u16)rx_hdr;
 	hdr_off =3D (u16)(rx_hdr >> 16);
+
+	if (pkt_cnt =3D=3D 0)
+		return 0;
+
+	/* Make sure that the bounds of the metadata array are inside the SKB
+	 * (and in front of the counter at the end).
+	 */
+	if (pkt_cnt * 2 + hdr_off > skb->len)
+		return 0;
 	pkt_hdr =3D (u32 *)(skb->data + hdr_off);
=20
-	while (pkt_cnt--) {
+	/* Packets must not overlap the metadata array */
+	skb_trim(skb, hdr_off);
+
+	for (; ; pkt_cnt--, pkt_hdr++) {
 		u16 pkt_len;
=20
 		le32_to_cpus(pkt_hdr);
 		pkt_len =3D (*pkt_hdr >> 16) & 0x1fff;
=20
-		/* Check CRC or runt packet */
-		if ((*pkt_hdr & AX_RXHDR_CRC_ERR) ||
-		    (*pkt_hdr & AX_RXHDR_DROP_ERR)) {
-			skb_pull(skb, (pkt_len + 7) & 0xFFF8);
-			pkt_hdr++;
-			continue;
-		}
-
-		if (pkt_cnt =3D=3D 0) {
-			skb->len =3D pkt_len;
-			/* Skip IP alignment pseudo header */
-			skb_pull(skb, 2);
-			skb_set_tail_pointer(skb, skb->len);
-			skb->truesize =3D pkt_len + sizeof(struct sk_buff);
-			ax88179_rx_checksum(skb, pkt_hdr);
-			return 1;
-		}
+		if (pkt_len > skb->len)
+			return 0;
=20
-		ax_skb =3D skb_clone(skb, GFP_ATOMIC);
-		if (ax_skb) {
+		/* Check CRC or runt packet */
+		if (((*pkt_hdr & (AX_RXHDR_CRC_ERR | AX_RXHDR_DROP_ERR)) =3D=3D 0) &&
+		    pkt_len >=3D 2 + ETH_HLEN) {
+			bool last =3D (pkt_cnt =3D=3D 0);
+
+			if (last) {
+				ax_skb =3D skb;
+			} else {
+				ax_skb =3D skb_clone(skb, GFP_ATOMIC);
+				if (!ax_skb)
+					return 0;
+			}
 			ax_skb->len =3D pkt_len;
 			/* Skip IP alignment pseudo header */
 			skb_pull(ax_skb, 2);
 			skb_set_tail_pointer(ax_skb, ax_skb->len);
 			ax_skb->truesize =3D pkt_len + sizeof(struct sk_buff);
 			ax88179_rx_checksum(ax_skb, pkt_hdr);
+
+			if (last)
+				return 1;
+
 			usbnet_skb_return(dev, ax_skb);
-		} else {
-			return 0;
 		}
=20
-		skb_pull(skb, (pkt_len + 7) & 0xFFF8);
-		pkt_hdr++;
+		/* Trim this packet away from the SKB */
+		if (!skb_pull(skb, (pkt_len + 7) & 0xFFF8))
+			return 0;
 	}
-	return 1;
 }
=20
 static struct sk_buff *

base-commit: 6b09c9f0e648f3b91449afb6a308488f3af414c1
--=20
2.35.1.265.g69c8d7142f-goog

