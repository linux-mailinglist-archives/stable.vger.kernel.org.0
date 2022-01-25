Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC5549B9D3
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 18:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237857AbiAYRNK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 12:13:10 -0500
Received: from nef2.ens.fr ([129.199.96.40]:49812 "EHLO nef.ens.fr"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1381364AbiAYRKv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jan 2022 12:10:51 -0500
X-Greylist: delayed 3646 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Jan 2022 12:10:49 EST
X-ENS-nef-client:   129.199.1.22 ( name = clipper-gw.ens.fr )
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ens.fr; s=default;
        t=1643126990; bh=YSzW5KR/C5EBASq9C5Wi7aVjUQpqrWLAq1Ke4z5Bo8c=;
        h=From:Subject:To:Date:From;
        b=O1SdGDhtKVmaoYMboJWEu7aPqH3qqDo3yXAf2/5ywH9jIgoXujlyROIXJDQdPdTL+
         ZMnAgRL+yzlyRJyCtRqXOIPhUHW2U8r8zBGCStgEldcKrv6TGwHpy3p4JVITXBOe6+
         pYKgOnnTjybY2aXtj9z5s+fZZpGbWmZWsIL76nNo=
Received: from clipper.ens.fr (clipper-gw.ens.fr [129.199.1.22])
          by nef.ens.fr (8.14.4/1.01.28121999) with ESMTP id 20PG9nPk000676
          for <stable@vger.kernel.org>; Tue, 25 Jan 2022 17:09:50 +0100
Received: from  [172.23.44.149] using smtps by clipper.ens.fr (8.14.4/jb-1.1)
       id 20PG9n53070897 for <stable@vger.kernel.org>; Tue, 25 Jan 2022 17:09:49 +0100 (authenticated user gbertholon)
X-ENS-Received:  (maths.r-prg.net.univ-paris7.fr [81.194.27.158])
From:   Guillaume Bertholon <guillaume.bertholon@ens.fr>
Subject: Misplaced patch application? (stable/linux-4.4.y)
To:     stable@vger.kernel.org
Message-ID: <10ff8d1e-60d8-2f93-98d1-d1671dd412f8@ens.fr>
Date:   Tue, 25 Jan 2022 17:09:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (nef.ens.fr [129.199.96.32]); Tue, 25 Jan 2022 17:09:50 +0100 (CET)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I'm working on a tool for (reliably) transferring diffs across
versions of a given C code. To evaluate my tool, I have been comparing
the output of my tool against the manual backports in the stable
branch.

In the process, I have found some oddities in some backported patches
which, I believe, are incorrect. In all cases, the root cause seems to
be that `patch` was able to apply a backported diff after some fuzzy
matching but did so at a wrong location (IMHO). Below is an example. I
can report the others if there is indeed a problem.


On the branch stable/linux-4.4.y, the upstream patch

   b560a208cda0297fef6ff85bbfd58a8f0a52a543
   Bluetooth: MGMT: Fix not checking if BT_HS is enabled

is backported as commit

   5abe9f99f5129bee5492072ff76b91ec4fad485b.


If we look at both commits we have:

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Upstream
  b560a208cda0297fef6ff85bbfd58a8f0a52a543
%%%%%%%%%

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 0b711ad..12d7b36 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
[...]
@@ -1817,6 +1818,10 @@ static int set_hs(struct sock *sk, struct hci_dev *hdev, void *data, u16 len)
 
        bt_dev_dbg(hdev, "sock %p", sk);
 
+       if (!IS_ENABLED(CONFIG_BT_HS))
+               return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_HS,
+                                      MGMT_STATUS_NOT_SUPPORTED);
+
        status = mgmt_bredr_support(hdev);
        if (status)
                return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_HS, status);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Backported
  5abe9f99f5129bee5492072ff76b91ec4fad485b
%%%%%%%%%

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index ecc3da6..ee761fb 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
[...]
@@ -2281,6 +2282,10 @@ static int set_link_security(struct sock *sk, struct hci_dev *hdev, void *data,
 
        BT_DBG("request for %s", hdev->name);
 
+       if (!IS_ENABLED(CONFIG_BT_HS))
+               return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_HS,
+                                      MGMT_STATUS_NOT_SUPPORTED);
+
        status = mgmt_bredr_support(hdev);
        if (status)
                return mgmt_cmd_status(sk, hdev->id, MGMT_OP_SET_LINK_SECURITY,


I suspect that this does *not* reflect the intent of the orignal patch
(which was addressing an issue in `set_hs`) whereas, here, the
backported patch is somewhat arbitrarily modifying `set_link_security`
while `set_hs` remains as-is.

Is this indeed an issue? Should I report on the other cases as well?

- Guillaume Bertholon

