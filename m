Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B91C2912A0
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 17:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438208AbgJQP2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 11:28:50 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:39636 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391902AbgJQP2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 11:28:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1602948529; x=1634484529;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=XeVq3/xgbxsKpPlk9svNS2UsK0tY1rhWSiWpoBHf8uo=;
  b=ONkl8ehMna7hlEvtcB+1iyYumKc1F6xc10qbG4MIF+qe354WrS4SupHF
   fUXye2T9V0qw6DPcX+4sTpu73eb2q0bEwo4n+syuJkldOTD9raECWnk4I
   aab0gZjZcifMvHMF19YUnfQZkBA+nZJUZKAQ6OvSsP3n23tfzXTV7WZ7+
   0=;
X-IronPort-AV: E=Sophos;i="5.77,387,1596499200"; 
   d="scan'208";a="85535843"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 17 Oct 2020 15:28:43 +0000
Received: from EX13MTAUEE002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2a-90c42d1d.us-west-2.amazon.com (Postfix) with ESMTPS id 10169A1848
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 15:28:43 +0000 (UTC)
Received: from EX13D11UEE003.ant.amazon.com (10.43.62.248) by
 EX13MTAUEE002.ant.amazon.com (10.43.62.24) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 17 Oct 2020 15:28:41 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D11UEE003.ant.amazon.com (10.43.62.248) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sat, 17 Oct 2020 15:28:41 +0000
Received: from dev-dsk-pboris-1f-f9682a47.us-east-1.amazon.com (10.1.57.236)
 by mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Sat, 17 Oct 2020 15:28:41 +0000
Received: by dev-dsk-pboris-1f-f9682a47.us-east-1.amazon.com (Postfix, from userid 5360108)
        id B4FCCA3ED2; Sat, 17 Oct 2020 15:28:41 +0000 (UTC)
From:   Boris Protopopov <pboris@amazon.com>
CC:     <stable@vger.kernel.org>, Boris Protopopov <pboris@amazon.com>
Subject: [PATCH 4.9-5.8] Convert trailing spaces and periods in path components
Date:   Sat, 17 Oct 2020 15:28:39 +0000
Message-ID: <20201017152839.4398-1-pboris@amazon.com>
X-Mailer: git-send-email 2.15.3.AMZN
MIME-Version: 1.0
Content-Type: text/plain
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When converting trailing spaces and periods in paths, do so
for every component of the path, not just the last component.
If the conversion is not done for every path component, then
subsequent operations in directories with trailing spaces or
periods (e.g. create(), mkdir()) will fail with ENOENT. This
is because on the server, the directory will have a special
symbol in its name, and the client needs to provide the same.

Cc: <stable@vger.kernel.org> # 4.9.x-5.8.x
Signed-off-by: Boris Protopopov <pboris@amazon.com>
---
 fs/cifs/cifs_unicode.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_unicode.c b/fs/cifs/cifs_unicode.c
index 498777d859eb..9bd03a231032 100644
--- a/fs/cifs/cifs_unicode.c
+++ b/fs/cifs/cifs_unicode.c
@@ -488,7 +488,13 @@ cifsConvertToUTF16(__le16 *target, const char *source, int srclen,
 		else if (map_chars == SFM_MAP_UNI_RSVD) {
 			bool end_of_string;
 
-			if (i == srclen - 1)
+			/**
+			 * Remap spaces and periods found at the end of every
+			 * component of the path. The special cases of '.' and
+			 * '..' do not need to be dealt with explicitly because
+			 * they are addressed in namei.c:link_path_walk().
+			 **/
+			if ((i == srclen - 1) || (source[i+1] == '\\'))
 				end_of_string = true;
 			else
 				end_of_string = false;
-- 
2.18.4

