Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB564F52B7
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 18:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726445AbfKHRlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 12:41:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:56692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726232AbfKHRlV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 12:41:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D199F206C3;
        Fri,  8 Nov 2019 17:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573234880;
        bh=rrrG1E/nJ7+MyKwH+aaUqPIU+kw9kpLz5S1MXRgV398=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nO+NomMlw5nV7KoDyC20RrXqD0ORHnxe5ETTHBOsVZim6GeF3dRERLd0D8IlRND/g
         GJAWSyrdn5ilBrYntRWFAQEmh/wpYD+IC6u9j+rjbRnojQeR5ZDU0zxhPe3Ts9oSS7
         kBCNAOxRixyhpFmYDjyvkfF6al9ohK0m5tgkj/Ug=
Date:   Fri, 8 Nov 2019 18:41:18 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Wolfgang Walter <linux@stwm.de>
Cc:     drbd-dev@lists.linbit.com, stable@vger.kernel.org
Subject: Re: stable 4.19.80 and 4.19.81: BAD! BarrierAck seen in drbd
Message-ID: <20191108174118.GA1212727@kroah.com>
References: <4418981.SUHPA3XYOi@stwm.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4418981.SUHPA3XYOi@stwm.de>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 08, 2019 at 05:38:13PM +0100, Wolfgang Walter wrote:
> Hello,
> 
> starting with 4.19.80 we saw twice this message from drbd (primary):
> 
> [335776.845165] drbd fastexport: BAD! BarrierAck #24834877 received, expected #24834876!
> [335776.845272] drbd fastexport: peer( Secondary -> Unknown ) conn( Connected -> ProtocolError ) pdsk( UpToDate -> DUnknown ) 
> [335776.845359] drbd fastexport: ack_receiver terminated
> [335776.845361] drbd fastexport: Terminating drbd_a_fastexpo
> [335776.845452] block drbd131: new current UUID E5F844267DB80A79:9823CD86802A0EC5:D37ECA3CF80CEEE3:D37DCA3CF80CEEE3
> [335776.845790] block drbd132: new current UUID B243958413F455E9:E107A4DF8E316F71:F05164996BFE9341:F05064996BFE9341
> [335776.846148] block drbd133: new current UUID 6E661C621E6C22E5:3271D34B1D818E09:6BA25176D9D79A5F:6BA15176D9D79A5F
> [335776.895617] drbd fastexport: Connection closed
> [335776.895764] drbd fastexport: conn( ProtocolError -> Unconnected ) 
> [335776.895767] drbd fastexport: receiver terminated
> [335776.895768] drbd fastexport: Restarting receiver thread
> [335776.895769] drbd fastexport: receiver (re)started
> [335776.895783] drbd fastexport: conn( Unconnected -> WFConnection ) 
> [335782.092297] drbd fastexport: Handshake successful: Agreed network protocol version 101
> [335782.092301] drbd fastexport: Feature flags enabled on protocol level: 0x7 TRIM THIN_RESYNC WRITE_SAME.
> [335782.092489] drbd fastexport: Peer authenticated using 32 bytes HMAC
> [335782.092577] drbd fastexport: conn( WFConnection -> WFReportParams ) 
> [335782.092587] drbd fastexport: Starting ack_recv thread (from drbd_r_fastexpo [1925])
> [335782.142516] block drbd131: drbd_sync_handshake:
> [335782.142522] block drbd131: self E5F844267DB80A79:9823CD86802A0EC5:D37ECA3CF80CEEE3:D37DCA3CF80CEEE3 bits:8180 flags:0
> [335782.142527] block drbd131: peer 9823CD86802A0EC4:0000000000000000:D37ECA3CF80CEEE2:D37DCA3CF80CEEE3 bits:0 flags:0
> [335782.142530] block drbd131: uuid_compare()=1 by rule 70
> [335782.142539] block drbd131: peer( Unknown -> Secondary ) conn( WFReportParams -> WFBitMapS ) pdsk( DUnknown -> Consistent ) 
> [335782.153913] block drbd131: send bitmap stats [Bytes(packets)]: plain 0(0), RLE 438(1), total 438; compression: 100.0%
> [335782.178564] block drbd132: drbd_sync_handshake:
> [335782.178570] block drbd132: self B243958413F455E9:E107A4DF8E316F71:F05164996BFE9341:F05064996BFE9341 bits:16198 flags:0
> [335782.178574] block drbd132: peer E107A4DF8E316F70:0000000000000000:F05164996BFE9340:F05064996BFE9341 bits:0 flags:0
> [335782.178578] block drbd132: uuid_compare()=1 by rule 70
> [335782.178587] block drbd132: peer( Unknown -> Secondary ) conn( WFReportParams -> WFBitMapS ) pdsk( DUnknown -> Consistent ) 
> [335782.191705] block drbd132: send bitmap stats [Bytes(packets)]: plain 0(0), RLE 721(1), total 721; compression: 100.0%
> [335782.206444] block drbd133: drbd_sync_handshake:
> [335782.206447] block drbd133: self 6E661C621E6C22E5:3271D34B1D818E09:6BA25176D9D79A5F:6BA15176D9D79A5F bits:7775 flags:0
> [335782.206450] block drbd133: peer 3271D34B1D818E08:0000000000000000:6BA25176D9D79A5E:6BA15176D9D79A5F bits:0 flags:0
> [335782.206452] block drbd133: uuid_compare()=1 by rule 70
> [335782.206459] block drbd133: peer( Unknown -> Secondary ) conn( WFReportParams -> WFBitMapS ) pdsk( DUnknown -> Consistent ) 
> [335782.206734] block drbd131: receive bitmap stats [Bytes(packets)]: plain 0(0), RLE 438(1), total 438; compression: 100.0%
> [335782.206738] block drbd131: helper command: /sbin/drbdadm before-resync-source minor-131
> [335782.214351] block drbd131: helper command: /sbin/drbdadm before-resync-source minor-131 exit code 0 (0x0)
> [335782.214376] block drbd131: conn( WFBitMapS -> SyncSource ) pdsk( Consistent -> Inconsistent ) 
> [335782.214395] block drbd131: Began resync as SyncSource (will sync 33104 KB [8276 bits set]).
> [335782.214746] block drbd132: receive bitmap stats [Bytes(packets)]: plain 0(0), RLE 721(1), total 721; compression: 100.0%
> [335782.214749] block drbd132: helper command: /sbin/drbdadm before-resync-source minor-132
> [335782.217368] block drbd132: helper command: /sbin/drbdadm before-resync-source minor-132 exit code 0 (0x0)
> [335782.217379] block drbd132: conn( WFBitMapS -> SyncSource ) pdsk( Consistent -> Inconsistent ) 
> [335782.217391] block drbd132: Began resync as SyncSource (will sync 65132 KB [16283 bits set]).
> [335782.218079] block drbd133: send bitmap stats [Bytes(packets)]: plain 0(0), RLE 290(1), total 290; compression: 100.0%
> [335782.218106] block drbd131: updated sync UUID E5F844267DB80A79:9824CD86802A0EC5:9823CD86802A0EC5:D37ECA3CF80CEEE3
> [335782.218450] block drbd132: updated sync UUID B243958413F455E9:E108A4DF8E316F71:E107A4DF8E316F71:F05164996BFE9341
> [335782.225868] block drbd133: receive bitmap stats [Bytes(packets)]: plain 0(0), RLE 290(1), total 290; compression: 100.0%
> [335782.225873] block drbd133: helper command: /sbin/drbdadm before-resync-source minor-133
> [335782.227420] block drbd133: helper command: /sbin/drbdadm before-resync-source minor-133 exit code 0 (0x0)
> [335782.227438] block drbd133: conn( WFBitMapS -> SyncSource ) pdsk( Consistent -> Inconsistent ) 
> [335782.227461] block drbd133: Began resync as SyncSource (will sync 31456 KB [7864 bits set]).
> [335782.227508] block drbd133: updated sync UUID 6E661C621E6C22E5:3272D34B1D818E09:3271D34B1D818E09:6BA25176D9D79A5F
> [335791.633014] block drbd133: Resync done (total 9 sec; paused 0 sec; 3492 K/sec)
> [335791.633020] block drbd133: 0 % had equal checksums, eliminated: 92K; transferred 31364K total 31456K
> [335791.633026] block drbd133: updated UUIDs 6E661C621E6C22E5:0000000000000000:3272D34B1D818E09:3271D34B1D818E09
> [335791.633036] block drbd133: conn( SyncSource -> Connected ) pdsk( Inconsistent -> UpToDate ) 
> [335791.847326] block drbd131: Resync done (total 9 sec; paused 0 sec; 3676 K/sec)
> [335791.847329] block drbd131: 0 % had equal checksums, eliminated: 152K; transferred 32952K total 33104K
> [335791.847332] block drbd131: updated UUIDs E5F844267DB80A79:0000000000000000:9824CD86802A0EC5:9823CD86802A0EC5
> [335791.847336] block drbd131: conn( SyncSource -> Connected ) pdsk( Inconsistent -> UpToDate ) 
> [335795.577446] block drbd132: Resync done (total 13 sec; paused 0 sec; 5008 K/sec)
> [335795.577450] block drbd132: 0 % had equal checksums, eliminated: 32K; transferred 65100K total 65132K
> [335795.577456] block drbd132: updated UUIDs B243958413F455E9:0000000000000000:E108A4DF8E316F71:E107A4DF8E316F71
> [335795.577465] block drbd132: conn( SyncSource -> Connected ) pdsk( Inconsistent -> UpToDate )
> 
> 
> 
> Both times the difference between the BarrierAck was 1.
> 
> We didn't use 4.19.79. We never saw this message with 4.19.78 or ealier.
> 
> After the first time this happened we saw a filesystem corruption.
> 
> 
> Setup:
> 
> The drbd fastexport consists of three volumes 1, 2 and 3
> 
> Each volume is backed by a logical volume
> 
> 	drbd_fastexport01
> 	drbd_fastexport02
> 	drbd_fastexport03
> 	
> of an LVM volumegroup
> 	drbddisks_fast
> 
> This logical volumes are each on there own physical devices (which are raid1).
> 
> These raid1 are based on SSDs attached to an mpt3sas driven controller.
> 
> 
> (both sides are setup like that).

Any chance you can run 'git bisect' between the two kernels (bad and
good) and find the offending commit?

Also, does 5.3.9 work for you?

thanks,

greg k-h
