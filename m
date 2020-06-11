Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1611F5FFA
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 04:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgFKC01 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 22:26:27 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63693 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgFKC0Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 22:26:25 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200611022621epoutp02b8b861c160452d26220b7bd5047d3630~XXDZNjkiL0905209052epoutp02b
        for <stable@vger.kernel.org>; Thu, 11 Jun 2020 02:26:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200611022621epoutp02b8b861c160452d26220b7bd5047d3630~XXDZNjkiL0905209052epoutp02b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1591842381;
        bh=fBKyV3l/gqu0fqM1IfprJo2DLtP0K5DetVQ3tnGKVfg=;
        h=From:To:Cc:Subject:Date:References:From;
        b=gIa3Z0smTzLFCQWtGXCA7PGF0zDWCutW2ADng36Y5SG/7L5gEkp41e04UYvun9SOW
         lnYmde1qD55EeidpYOTfiFtJjaGzHmLMWMB2xOL2H57YEnlB0cg5YQvnwW/1ADQhpX
         vHoO/7nQmkrwmYMx6EgT+twX3NxUMrPDm9oLc5bY=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20200611022621epcas1p23387ad0ba15c5052c1ce3675dd906588~XXDY_zQIf2268522685epcas1p2-;
        Thu, 11 Jun 2020 02:26:21 +0000 (GMT)
Received: from epsmges1p5.samsung.com (unknown [182.195.40.165]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 49j75S2tbwzMqYm3; Thu, 11 Jun
        2020 02:26:20 +0000 (GMT)
Received: from epcas1p3.samsung.com ( [182.195.41.47]) by
        epsmges1p5.samsung.com (Symantec Messaging Gateway) with SMTP id
        8C.C2.28578.B4691EE5; Thu, 11 Jun 2020 11:26:19 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTPA id
        20200611022619epcas1p46fd9d1d54396f0a4206b550949377d99~XXDXG4U3p2623526235epcas1p4b;
        Thu, 11 Jun 2020 02:26:19 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200611022619epsmtrp20a4eafa9091b25fa77161a88a728af10~XXDXGOz600085200852epsmtrp2_;
        Thu, 11 Jun 2020 02:26:19 +0000 (GMT)
X-AuditID: b6c32a39-8dfff70000006fa2-32-5ee1964b9b55
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        B8.3B.08303.B4691EE5; Thu, 11 Jun 2020 11:26:19 +0900 (KST)
Received: from localhost.localdomain (unknown [10.88.103.87]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200611022619epsmtip1ed4d948064c3f1fcb3f98a0949d7988d~XXDW8jgFo3014530145epsmtip1R;
        Thu, 11 Jun 2020 02:26:19 +0000 (GMT)
From:   Namjae Jeon <namjae.jeon@samsung.com>
To:     linux-cifs@vger.kernel.org
Cc:     linkinjeon@kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Stable <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steve French <smfrench@gmail.com>
Subject: [PATCH] smb3: add indatalen that can be a non-zero value to
 calculation of credit charge in smb2 ioctl
Date:   Thu, 11 Jun 2020 11:21:19 +0900
Message-Id: <20200611022119.31506-1-namjae.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJKsWRmVeSWpSXmKPExsWy7bCmvq73tIdxBre+qFg0vj3NYjFx2lJm
        ixf/dzFb/Jheb/HmxWE2iwUbHzE6sHnsnHWX3WPTqk42j74tqxg91m+5yuLxeZNcAGtUjk1G
        amJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0AFKCmWJOaVA
        oYDE4mIlfTubovzSklSFjPziElul1IKUnAJDgwK94sTc4tK8dL3k/FwrQwMDI1OgyoScjBXb
        L7MUfOCtmNM/iamB8Tl3FyMnh4SAicSW+d1MXYxcHEICOxglbp18zwzhfGKUOLpqJxtIlZDA
        Z0aJ4w/5YDoONjxhhSjaxSjR2bWXFa5jevMDxi5GDg42AW2JP1tEQRpEBOQk1m46yQJSwyyw
        Cmjqks3MIAlhgUKJ9ev/MoLYLAKqEnOPnQWL8wrYSOxY/5wVYpu8xOoNB8BOkhBYxS5x9nIn
        G0TCReLW8aksELawxKvjW9ghbCmJz+/2soEcISFQLfFxPzNEuINR4sV3WwjbWOLm+g2sICXM
        ApoS63fpQ4QVJXb+ngt2DrMAn8S7rz2sEFN4JTrahCBKVCX6Lh1mgrClJbraP0At9ZD4PamL
        BRJWsRLnWpexTmCUnYWwYAEj4ypGsdSC4tz01GLDAlPkONrECE5TWpY7GKe//aB3iJGJg/EQ
        owQHs5IIr6D4wzgh3pTEyqrUovz4otKc1OJDjKbA4JrILCWanA9MlHkl8YamRsbGxhYmZuZm
        psZK4rxO1hfihATSE0tSs1NTC1KLYPqYODilGpi4fddOufW+cuuV3VOWsrUHeBZa/rPJ5hHn
        2/whR95Z2WZh5Mqq7zLSly8d0Sjy+cX71Py2VtHfBfEJ0UKSfokFG8/4i/Ne/K6ycc6pVdMr
        F3dWzNlYUP5cNdCub/K51jNlyte97qx+K1V8pnKl0pzT337OTfnptvwkh4L0H3et+c9kzSca
        bjA36Cg5fun/tmk3Hxl+mZ6b3vXR4kH8o5SltXvOcK9kXV+3MlZ7ocaXSROe/J0ZHho3YcN1
        r4Zik30iX+ekdzyuLvNt9xWxs3l2q+Y2q7DgMs0DpRP9Gjx2J6wPlVjy8O9M26Wzt+5b6eB1
        eXLhLz213QEO1Y0n+XsXJZ5gmnJu6pfwprfZn5LvKrEUZyQaajEXFScCAOzoSD7cAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBJMWRmVeSWpSXmKPExsWy7bCSnK73tIdxBn3v+S0a355msZg4bSmz
        xYv/u5gtfkyvt3jz4jCbxYKNjxgd2Dx2zrrL7rFpVSebR9+WVYwe67dcZfH4vEkugDWKyyYl
        NSezLLVI3y6BK2PF9sssBR94K+b0T2JqYHzO3cXIySEhYCJxsOEJaxcjF4eQwA5GiQVvutkh
        EtISx06cYe5i5ACyhSUOHy6GqPnAKLGst4UJJM4moC3xZ4soSLmIgJzE2k0nWUBqmAXWMUo8
        OPqHFSQhLJAvcXvqEmYQm0VAVWLusbNgNq+AjcSO9c9ZIXbJS6zecIB5AiPPAkaGVYySqQXF
        uem5xYYFRnmp5XrFibnFpXnpesn5uZsYwYGjpbWDcc+qD3qHGJk4GA8xSnAwK4nwCoo/jBPi
        TUmsrEotyo8vKs1JLT7EKM3BoiTO+3XWwjghgfTEktTs1NSC1CKYLBMHp1QDU1J48uULrV/8
        nTTOnEuz/BB1+JOWQ0XP6aVHGvI+blu8kPuAaClDtqyoZfXapFnMfWxvWK2ZuS4Y3rz9eb99
        huvktgny3lECcqdXX89d/kioUdi0LX7nkdKIOR8Mdt1jnXz79sb70g/rJnO8q2A4lPNZY+rG
        e/HL+ZLmvTT9dmXGJ0Yux34LZZa+C8fbld7N/CPunH3u3rSEwCMq2x0CD0bf2eIXHrzepyUw
        7mMe2yRpRX2W5pXL/y60/33HVXJpx5rmcOfFJWYXbq2I3rAkJ3SR96yG6Fd27JkcDbpClXOu
        9RwK2jCRUzvE5906p6niAX+i5r/7Kndq8uzTEqe2borv7mteKiG46swUTV+HU0osxRmJhlrM
        RcWJAPhBMK+LAgAA
X-CMS-MailID: 20200611022619epcas1p46fd9d1d54396f0a4206b550949377d99
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200611022619epcas1p46fd9d1d54396f0a4206b550949377d99
References: <CGME20200611022619epcas1p46fd9d1d54396f0a4206b550949377d99@epcas1p4.samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Some of tests in xfstests failed with cifsd kernel server since commit
e80ddeb2f70e. cifsd kernel server validates credit charge from client
by calculating it base on max((InputCount + OutputCount) and
(MaxInputResponse + MaxOutputResponse)) according to specification.

MS-SMB2 specification describe credit charge calculation of smb2 ioctl :

If Connection.SupportsMultiCredit is TRUE, the server MUST validate
CreditCharge based on the maximum of (InputCount + OutputCount) and
(MaxInputResponse + MaxOutputResponse), as specified in section 3.3.5.2.5.
If the validation fails, it MUST fail the IOCTL request with
STATUS_INVALID_PARAMETER.

This patch add indatalen that can be a non-zero value to calculation of
credit charge in SMB2_ioctl_init().

Fixes: e80ddeb2f70e ("smb3: fix incorrect number of credits when ioctl
MaxOutputResponse > 64K")
Cc: Stable <stable@vger.kernel.org>
Cc: Aurelien Aptel <aaptel@suse.com>
Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
---
 fs/cifs/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index ded96b529a4d..86d894499fbb 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2973,7 +2973,9 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 	 * response size smaller.
 	 */
 	req->MaxOutputResponse = cpu_to_le32(max_response_size);
-	req->sync_hdr.CreditCharge = cpu_to_le16(DIV_ROUND_UP(max_response_size, SMB2_MAX_BUFFER_SIZE));
+	req->sync_hdr.CreditCharge =
+		cpu_to_le16(DIV_ROUND_UP(max(indatalen, max_response_size),
+					 SMB2_MAX_BUFFER_SIZE));
 	if (is_fsctl)
 		req->Flags = cpu_to_le32(SMB2_0_IOCTL_IS_FSCTL);
 	else
-- 
2.17.1

