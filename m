Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13868304B6F
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbhAZEpk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:45:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:58346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728305AbhAYSnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:43:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 997CE206FA;
        Mon, 25 Jan 2021 18:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600140;
        bh=jtw8wKPBp6rHPKRtnsL0ki0alJMiWT378Xll64O6+YA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLIr8pW+tyI1FDaHilv9YmeiP9V5Zwf3geSpwUtW1tkeLWv0WPW36G2tRblI8wbTF
         BNKIzJQ5xCdds03rlijjGfn0h8pRZYq+nmemBMDhFO00gd4sewVpYw9b46U2im1CxF
         OMl7SSNoXv2aUWldSNl9nev80WCwpp0s52ix1KVI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 46/58] net: dsa: mv88e6xxx: also read STU state in mv88e6250_g1_vtu_getnext
Date:   Mon, 25 Jan 2021 19:39:47 +0100
Message-Id: <20210125183158.687957547@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

commit 87fe04367d842c4d97a77303242d4dd4ac351e46 upstream.

mv88e6xxx_port_vlan_join checks whether the VTU already contains an
entry for the given vid (via mv88e6xxx_vtu_getnext), and if so, merely
changes the relevant .member[] element and loads the updated entry
into the VTU.

However, at least for the mv88e6250, the on-stack struct
mv88e6xxx_vtu_entry vlan never has its .state[] array explicitly
initialized, neither in mv88e6xxx_port_vlan_join() nor inside the
getnext implementation. So the new entry has random garbage for the
STU bits, breaking VLAN filtering.

When the VTU entry is initially created, those bits are all zero, and
we should make sure to keep them that way when the entry is updated.

Fixes: 92307069a96c (net: dsa: mv88e6xxx: Avoid VTU corruption on 6097)
Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Tobias Waldekranz <tobias@waldekranz.com>
Tested-by: Tobias Waldekranz <tobias@waldekranz.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/dsa/mv88e6xxx/global1_vtu.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/dsa/mv88e6xxx/global1_vtu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
@@ -357,6 +357,10 @@ int mv88e6185_g1_vtu_getnext(struct mv88
 		if (err)
 			return err;
 
+		err = mv88e6185_g1_stu_data_read(chip, entry);
+		if (err)
+			return err;
+
 		/* VTU DBNum[3:0] are located in VTU Operation 3:0
 		 * VTU DBNum[7:4] are located in VTU Operation 11:8
 		 */


