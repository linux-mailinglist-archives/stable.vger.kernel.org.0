Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB8317FFD1
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 15:09:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgCJOJv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 10:09:51 -0400
Received: from esa1.mentor.iphmx.com ([68.232.129.153]:55077 "EHLO
        esa1.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbgCJOJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 10:09:51 -0400
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Mar 2020 10:09:50 EDT
IronPort-SDR: hoPUw97u0bj2P9AnyZMmdxYlxYY+4U4hJufeVn7Bq+PjxzA3Nk5MdglmA2KsSts1pwZbxqCSL6
 m4oZW07C2Tyk3tUJEV5DbBDwcVmbzSP5V8fRayzphkgeYAhT/BCVhgAU6oXFkQeYs+FqlMcRgW
 QtpxL73R0P+RQjvqFEiuCQDRze8HirUR14C+V7DnmYi3/fLpcu6STZ3n1JndMc+W7lN0OFReDL
 GleeJRRpsSXDqmjAkh824icliRlI8IirkeBC0wIUlyG99G8JBYIw2z7ZIzwFJ2bC/ubmcOthx3
 KxI=
X-IronPort-AV: E=Sophos;i="5.70,537,1574150400"; 
   d="scan'208";a="48532895"
Received: from orw-gwy-01-in.mentorg.com ([192.94.38.165])
  by esa1.mentor.iphmx.com with ESMTP; 10 Mar 2020 06:02:45 -0800
IronPort-SDR: sMSfmGLHB1Ma66KK7XLtQuReHF/rwtP0wFzfp3MVExrFPSVAXqT7iNxNjdool8jTh3XBGD3exd
 IG6y8feok7EJrQNvn4alZIBZUJBK76VAmZOIvb5o/1kj24E6z5/Q6h4ugunajfkSqh+eekkmoi
 0vkaMDiOuTZ8S//j/j7WtLLHCE3v21grKse4RTZWCARKHcutyDbTPxfWcX6ViQdO6v/yFv6B+g
 5GkK7cCnD2myEnFYynlw/2jOnZTqoGQuaXEBnkFzxywAwfQHRt8sTtGJhZSHBH5TwEwGT9pUWQ
 RfQ=
From:   Dragos Tarcatu <dragos_tarcatu@mentor.com>
To:     <gregkh@linuxfoundation.org>
CC:     <broonie@kernel.org>, <dragos_tarcatu@mentor.com>,
        <stable@vger.kernel.org>
Subject: [PATCH v4.14] ASoC: topology: Fix memleak in soc_tplg_manifest_load()
Date:   Tue, 10 Mar 2020 16:02:11 +0200
Message-ID: <20200310140211.25468-1-dragos_tarcatu@mentor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <158378610642216@kroah.com>
References: <158378610642216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [137.202.0.90]
X-ClientProxiedBy: svr-ies-mbx-06.mgc.mentorg.com (139.181.222.6) To
 svr-ies-mbx-02.mgc.mentorg.com (139.181.222.2)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 242c46c023610dbc0213fc8fb6b71eb836bc5d95 upstream.

In case of ABI version mismatch, _manifest needs to be freed as
it is just a copy of the original topology manifest. However, if
a driver manifest handler is defined, that would get executed and
the cleanup is never reached. Fix that by getting the return status
of manifest() instead of returning directly.

Fixes: 583958fa2e52 ("ASoC: topology: Make manifest backward compatible from ABI v4")
Signed-off-by: Dragos Tarcatu <dragos_tarcatu@mentor.com>
Link: https://lore.kernel.org/r/20200207185325.22320-3-dragos_tarcatu@mentor.com
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 sound/soc/soc-topology.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index 72301bcad3bd..cf04739aed48 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -2330,7 +2330,7 @@ static int soc_tplg_manifest_load(struct soc_tplg *tplg,
 {
 	struct snd_soc_tplg_manifest *manifest, *_manifest;
 	bool abi_match;
-	int err;
+	int ret = 0;
 
 	if (tplg->pass != SOC_TPLG_PASS_MANIFEST)
 		return 0;
@@ -2343,19 +2343,19 @@ static int soc_tplg_manifest_load(struct soc_tplg *tplg,
 		_manifest = manifest;
 	} else {
 		abi_match = false;
-		err = manifest_new_ver(tplg, manifest, &_manifest);
-		if (err < 0)
-			return err;
+		ret = manifest_new_ver(tplg, manifest, &_manifest);
+		if (ret < 0)
+			return ret;
 	}
 
 	/* pass control to component driver for optional further init */
 	if (tplg->comp && tplg->ops && tplg->ops->manifest)
-		return tplg->ops->manifest(tplg->comp, _manifest);
+		ret = tplg->ops->manifest(tplg->comp, _manifest);
 
 	if (!abi_match)	/* free the duplicated one */
 		kfree(_manifest);
 
-	return 0;
+	return ret;
 }
 
 /* validate header magic, size and type */
-- 
2.17.1

