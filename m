Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A51112A8AE
	for <lists+stable@lfdr.de>; Wed, 25 Dec 2019 18:32:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbfLYRc3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Dec 2019 12:32:29 -0500
Received: from mail-il1-f173.google.com ([209.85.166.173]:41958 "EHLO
        mail-il1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfLYRc3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Dec 2019 12:32:29 -0500
Received: by mail-il1-f173.google.com with SMTP id f10so18734268ils.8
        for <stable@vger.kernel.org>; Wed, 25 Dec 2019 09:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=PKpJyBtEIf002SzETipXaQtd55JNwOEunh3OENoR0o8=;
        b=cipIW8T+TZT0nuRIiEjuHt1YY5n1Do56ac8KxLNK0jHxRD0wURZd6I4UggxMNov9JS
         v5Db82zk+Tf1S5R5juqIB+Cl+efyAvQq6UMXYuU9nZArtlj5ydr0qStGU6YFOSQ6rGhd
         m8tGq0Mg5V13UnXQ6rOWbdADRZb6CQ7btta1wJVkr2VMcLXAauPZL3dyp7N4BcpJqDpP
         Vb+GnWJSxLdrx9buG3P9KVa4Yhi6XSWwGrMmBPYVw/Vgarhp5hfBp5eH/i7LVeMd34F+
         LvAAY1DlnKGkjjjt5mZr29Ql0RObFuNI7n5kH4w1lO3SwQAsTT/ioEwbLc9/fFzpO7aF
         Xi/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=PKpJyBtEIf002SzETipXaQtd55JNwOEunh3OENoR0o8=;
        b=l1Xnhx2SIcavnOrTAXjyj2Lt2ALtkg0TK+pQqM4hr7w2Uh04EzBrz4PQMZSzRhuNwR
         /b9DN4LVoOGbn5Qfxwp7OAMnGk8II9ZmsHwUbeNLuNgMOUUQrkT4GRLiAf6JVLuo+Gxo
         BtB/3X2oGSUNMtLq+Ah/4FyopYFSiFhiDdx42Ye9TiDjUVqr0j/AHdQjv5tKGv9zv4Pe
         RRSl49elSMq61+WEst/s4t8zf6pGowzOZzinQohcrx+iBa0P8KOadedfz99NwMivpZFK
         ooaVlsxTKDn9hS6da+V56KIwaP7p6uiGECvWLGEUZsT4JeoseMuomDrM93aEoErVnUUw
         Bgbw==
X-Gm-Message-State: APjAAAX1eOolWmWLni5Gb2Qz+jX33jQCnwMi1VlkJJE8gTpsGZHeR+yW
        WU+Vo9yhLqYd06ZOqC24By0Ue3neD3t9ZLrwWZs=
X-Google-Smtp-Source: APXvYqwAtuTfIJhghAZTFCbn7dSwZW08O0VDF5W4kqH7BQBFdxOvI560sGo+mzvus+jy6Z1+X3Nik8eUCCHgIpk0e/8=
X-Received: by 2002:a92:9e97:: with SMTP id s23mr38185011ilk.139.1577295148514;
 Wed, 25 Dec 2019 09:32:28 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:ac0:9191:0:0:0:0:0 with HTTP; Wed, 25 Dec 2019 09:32:28
 -0800 (PST)
From:   youling 257 <youling257@gmail.com>
Date:   Thu, 26 Dec 2019 01:32:28 +0800
Message-ID: <CAOzgRdZY7byvK3+NGU2k9L3MDyo81=YdD-hpeW0eGN9Ftzm9fw@mail.gmail.com>
Subject: Re: usb: dwc3: gadget: Fix logical condition
To:     Tejas.Joglekar@synopsys.com
Cc:     joglekar@synopsys.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This patch caused g_mass_storage not working.

with this patch, device modprobe g_mass_storage file=/dev/block/mmcblk2p3,
[  255.255238] udc dwc3.3.auto: registering UDC driver [g_mass_storage]
[  255.255266] Mass Storage Function, version: 2009/09/11
[  255.255362] LUN: removable file: (no medium)
[  255.255533] lun0: open backing file: /dev/block/mmcblk2p3
[  255.255539] LUN: file: /dev/block/mmcblk2p3
[  255.255587] Number of LUNs=1
[  255.255675] g_mass_storage gadget: adding config #1 'Linux
File-Backed Storage'/0000000034b331d2
[  255.255681] g_mass_storage gadget: adding 'Mass Storage
Function'/000000009839a369 to config 'Linux File-Backed
Storage'/0000000034b331d2
[  255.256338] g_mass_storage gadget: I/O thread pid: 6312
[  255.256396] g_mass_storage gadget: cfg 1/0000000034b331d2 speeds:
super high full
[  255.256401] g_mass_storage gadget:   interface 0 = Mass Storage
Function/000000009839a369
[  255.256411] g_mass_storage gadget: Mass Storage Gadget, version: 2009/09/11
[  255.256464] g_mass_storage gadget: userspace failed to provide iSerialNumber
[  255.256548] g_mass_storage gadget: g_mass_storage ready
[  255.313503] init: Starting service 'wpa_supplicant'...
[  255.355209] g_mass_storage gadget: suspend
[  255.384831] init: Service 'wpa_supplicant' (pid 6314) exited with status 255
[  255.384891] init: Service 'wpa_supplicant' (pid 6314) killing any
children in process group
[  255.662885] g_mass_storage gadget: high-speed config #1: Linux
File-Backed Storage
[  255.663081] g_mass_storage gadget: set_config: interface 0 (Mass
Storage Function) requested delayed status
[  255.663089] g_mass_storage gadget: delayed_status count 1
[  255.663732] g_mass_storage gadget: usb_composite_setup_continue
[  255.663743] g_mass_storage gadget: usb_composite_setup_continue:
Completing delayed status
[  256.681607] g_mass_storage gadget: non-core control reqa1.fe v0000 i0000 l1
[  256.681613] g_mass_storage gadget: get max LUN

host not detect sda,
[49728.458139] usb 1-2.3: new high-speed USB device number 21 using xhci_hcd
[49728.544776] usb-storage 1-2.3:1.0: USB Mass Storage device detected

                                                 [49728.545875]
usb-storage 1-2.3:1.0: Quirks match for vid 0525 pid a4a5: 10000
[49728.546062] scsi host0: usb-storage 1-2.3:1.0


revert this patch, device modprobe g_mass_storage file=/dev/block/mmcblk2p3
[  405.766178] udc dwc3.3.auto: registering UDC driver [g_mass_storage]
[  405.766225] Mass Storage Function, version: 2009/09/11
[  405.766307] LUN: removable file: (no medium)
[  405.766532] lun0: open backing file: /dev/block/mmcblk2p3
[  405.766539] LUN: file: /dev/block/mmcblk2p3
[  405.766665] Number of LUNs=1
[  405.766736] g_mass_storage gadget: adding config #1 'Linux
File-Backed Storage'/0000000034b331d2
[  405.766747] g_mass_storage gadget: adding 'Mass Storage
Function'/00000000cbbcccdc to config 'Linux File-Backed
Storage'/0000000034b331d2
[  405.767498] g_mass_storage gadget: I/O thread pid: 6873
[  405.767509] g_mass_storage gadget: cfg 1/0000000034b331d2 speeds:
super high full
[  405.767512] g_mass_storage gadget:   interface 0 = Mass Storage
Function/00000000cbbcccdc
[  405.767519] g_mass_storage gadget: Mass Storage Gadget, version: 2009/09/11
[  405.767587] g_mass_storage gadget: userspace failed to provide iSerialNumber
[  405.767622] g_mass_storage gadget: g_mass_storage ready
[  405.866215] g_mass_storage gadget: suspend
[  406.175951] g_mass_storage gadget: high-speed config #1: Linux
File-Backed Storage
[  406.176130] g_mass_storage gadget: set_config: interface 0 (Mass
Storage Function) requested delayed status
[  406.176138] g_mass_storage gadget: delayed_status count 1
[  406.176186] g_mass_storage gadget: usb_composite_setup_continue
[  406.176211] g_mass_storage gadget: usb_composite_setup_continue:
Completing delayed status
[  407.202507] g_mass_storage gadget: non-core control reqa1.fe v0000 i0000 l1
[  407.202512] g_mass_storage gadget: get max LUN
[  407.203164] SCSI CDB: 12 00 00 00 24 00
[  407.203177] g_mass_storage gadget: SCSI command: INQUIRY;  Dc=6,
Di=36;  Hc=6, Hi=36
[  407.205991] SCSI CDB: 00 00 00 00 00 00
[  407.206005] g_mass_storage gadget: SCSI command: TEST UNIT READY;
Dc=6, Dn=0;  Hc=6, Hn=0
[  407.206008] g_mass_storage gadget: sending command-failure status
[  407.206012] g_mass_storage gadget:   sense data: SK x06, ASC x29,
ASCQ x00;  info x0
[  407.206279] SCSI CDB: 03 00 00 00 12 00
[  407.206287] g_mass_storage gadget: SCSI command: REQUEST SENSE;
Dc=6, Di=18;  Hc=6, Hi=18
[  407.207342] SCSI CDB: 00 00 00 00 00 00
[  407.207354] g_mass_storage gadget: SCSI command: TEST UNIT READY;
Dc=6, Dn=0;  Hc=6, Hn=0
[  407.207633] SCSI CDB: 25 00 00 00 00 00 00 00 00 00
[  407.207641] g_mass_storage gadget: SCSI command: READ CAPACITY;
Dc=10, Di=8;  Hc=10, Hi=8
[  407.208755] SCSI CDB: 1a 00 3f 00 c0 00
[  407.208766] g_mass_storage gadget: SCSI command: MODE SENSE(6);
Dc=6, Di=192;  Hc=6, Hi=192
[  407.208779] g_mass_storage gadget: bulk-in set halt
[  407.208782] g_mass_storage gadget: delayed bulk-in endpoint halt
[  407.320644] SCSI CDB: 1a 00 3f 00 c0 00
[  407.320662] g_mass_storage gadget: SCSI command: MODE SENSE(6);
Dc=6, Di=192;  Hc=6, Hi=192
[  407.320674] g_mass_storage gadget: bulk-in set halt
[  407.320676] g_mass_storage gadget: delayed bulk-in endpoint halt
[  407.440335] SCSI CDB: 00 00 00 00 00 00

host can detect sda,
[49878.915966] usb 1-2.3: new high-speed USB device number 23 using xhci_hcd
[49878.999260] usb-storage 1-2.3:1.0: USB Mass Storage device detected

                                                 [49879.001165]
usb-storage 1-2.3:1.0: Quirks match for vid 0525 pid a4a5: 10000
[49879.001676] scsi host0: usb-storage 1-2.3:1.0

                                                 [49880.026002] scsi
0:0:0:0: Direct-Access     Linux    File-Stor Gadget 0503 PQ: 0 ANSI:
2
[49880.027243] scsi 0:0:0:0: Attached scsi generic sg0 type 0

                                                 [49880.028852] sd
0:0:0:0: Power-on or device reset occurred
[49880.030081] sd 0:0:0:0: [sda] 10485760 512-byte logical blocks:
(5.37 GB/5.00 GiB)
                                                     [49880.142046] sd
0:0:0:0: [sda] Write Protect is off
[49880.142186] sd 0:0:0:0: [sda] Mode Sense: 0f 00 00 00

                                                 [49880.253720] sd
0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
[49880.500337] audit: type=1400 audit(1577294060.839:15853): avc:
denied  { noatsecure } for  pid=9278 comm="sh" scontext=u:r:vold:s0
tcontext=u:r:sgdisk:s0 tclass=process permissive=1      [49880.596496]
sd 0:0:0:0: [sda] Attached SCSI disk
