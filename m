Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3222C064E
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730633AbgKWM3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:29:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:40200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730111AbgKWM3q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:29:46 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C1422076E;
        Mon, 23 Nov 2020 12:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134584;
        bh=IRikNx+9iaVeT05YLzNPP4noutUwUawijr9vZp+PpPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lmxkipY2q6pFuvFyPV9GRwb4riVAW+cv9b9n81kJaRuEazQv//5GNPUmqBrjRUNeT
         YwhZOJA2Rr0UEQlDHXOCbPL74nLcmys1K+33u1/Lct6ykxpHP/iGGPVDu1fjr30/k2
         kybasvDooTJMiq3924hOvD4VCxBr/CHHxPAvIwb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Waldekranz <tobias@waldekranz.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 11/91] net: dsa: mv88e6xxx: Avoid VTU corruption on 6097
Date:   Mon, 23 Nov 2020 13:21:31 +0100
Message-Id: <20201123121809.848691396@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121809.285416732@linuxfoundation.org>
References: <20201123121809.285416732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Waldekranz <tobias@waldekranz.com>

[ Upstream commit 92307069a96c07d9b6e74b96b79390e7cd7d2111 ]

As soon as you add the second port to a VLAN, all other port
membership configuration is overwritten with zeroes. The HW interprets
this as all ports being "unmodified members" of the VLAN.

In the simple case when all ports belong to the same VLAN, switching
will still work. But using multiple VLANs or trying to set multiple
ports as tagged members will not work.

On the 6352, doing a VTU GetNext op, followed by an STU GetNext op
will leave you with both the member- and state- data in the VTU/STU
data registers. But on the 6097 (which uses the same implementation),
the STU GetNext will override the information gathered from the VTU
GetNext.

Separate the two stages, parsing the result of the VTU GetNext before
doing the STU GetNext.

We opt to update the existing implementation for all applicable chips,
as opposed to creating a separate callback for 6097, because although
the previous implementation did work for (at least) 6352, the
datasheet does not mention the masking behavior.

Fixes: ef6fcea37f01 ("net: dsa: mv88e6xxx: get STU entry on VTU GetNext")
Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
Link: https://lore.kernel.org/r/20201112114335.27371-1-tobias@waldekranz.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mv88e6xxx/global1_vtu.c |   59 ++++++++++++++++++++++++++------
 1 file changed, 49 insertions(+), 10 deletions(-)

--- a/drivers/net/dsa/mv88e6xxx/global1_vtu.c
+++ b/drivers/net/dsa/mv88e6xxx/global1_vtu.c
@@ -127,11 +127,9 @@ static int mv88e6xxx_g1_vtu_vid_write(st
  * Offset 0x08: VTU/STU Data Register 2
  * Offset 0x09: VTU/STU Data Register 3
  */
-
-static int mv88e6185_g1_vtu_data_read(struct mv88e6xxx_chip *chip,
-				      struct mv88e6xxx_vtu_entry *entry)
+static int mv88e6185_g1_vtu_stu_data_read(struct mv88e6xxx_chip *chip,
+					  u16 *regs)
 {
-	u16 regs[3];
 	int i;
 
 	/* Read all 3 VTU/STU Data registers */
@@ -144,12 +142,45 @@ static int mv88e6185_g1_vtu_data_read(st
 			return err;
 	}
 
-	/* Extract MemberTag and PortState data */
+	return 0;
+}
+
+static int mv88e6185_g1_vtu_data_read(struct mv88e6xxx_chip *chip,
+				      struct mv88e6xxx_vtu_entry *entry)
+{
+	u16 regs[3];
+	int err;
+	int i;
+
+	err = mv88e6185_g1_vtu_stu_data_read(chip, regs);
+	if (err)
+		return err;
+
+	/* Extract MemberTag data */
 	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
 		unsigned int member_offset = (i % 4) * 4;
-		unsigned int state_offset = member_offset + 2;
 
 		entry->member[i] = (regs[i / 4] >> member_offset) & 0x3;
+	}
+
+	return 0;
+}
+
+static int mv88e6185_g1_stu_data_read(struct mv88e6xxx_chip *chip,
+				      struct mv88e6xxx_vtu_entry *entry)
+{
+	u16 regs[3];
+	int err;
+	int i;
+
+	err = mv88e6185_g1_vtu_stu_data_read(chip, regs);
+	if (err)
+		return err;
+
+	/* Extract PortState data */
+	for (i = 0; i < mv88e6xxx_num_ports(chip); ++i) {
+		unsigned int state_offset = (i % 4) * 4 + 2;
+
 		entry->state[i] = (regs[i / 4] >> state_offset) & 0x3;
 	}
 
@@ -322,6 +353,10 @@ int mv88e6185_g1_vtu_getnext(struct mv88
 		if (err)
 			return err;
 
+		err = mv88e6185_g1_stu_data_read(chip, entry);
+		if (err)
+			return err;
+
 		/* VTU DBNum[3:0] are located in VTU Operation 3:0
 		 * VTU DBNum[7:4] are located in VTU Operation 11:8
 		 */
@@ -347,16 +382,20 @@ int mv88e6352_g1_vtu_getnext(struct mv88
 		return err;
 
 	if (entry->valid) {
-		/* Fetch (and mask) VLAN PortState data from the STU */
-		err = mv88e6xxx_g1_vtu_stu_get(chip, entry);
+		err = mv88e6185_g1_vtu_data_read(chip, entry);
 		if (err)
 			return err;
 
-		err = mv88e6185_g1_vtu_data_read(chip, entry);
+		err = mv88e6xxx_g1_vtu_fid_read(chip, entry);
 		if (err)
 			return err;
 
-		err = mv88e6xxx_g1_vtu_fid_read(chip, entry);
+		/* Fetch VLAN PortState data from the STU */
+		err = mv88e6xxx_g1_vtu_stu_get(chip, entry);
+		if (err)
+			return err;
+
+		err = mv88e6185_g1_stu_data_read(chip, entry);
 		if (err)
 			return err;
 	}


